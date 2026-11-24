#!/usr/bin/env python3
import argparse
import filecmp
import struct
import subprocess
import tempfile
import zlib
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
FDT_MAGIC = bytes.fromhex("d00dfeed")
SPARSE_MAGIC = bytes.fromhex("3aff26ed")


def partition(image, name):
    with image.open("rb") as source:
        for sector in (512, 4096):
            source.seek(sector)
            header = source.read(sector)
            if header[:8] != b"EFI PART":
                continue
            header_size, checksum = struct.unpack_from("<II", header, 12)
            if not 92 <= header_size <= sector:
                continue
            checked_header = bytearray(header[:header_size])
            checked_header[16:20] = b"\0" * 4
            if zlib.crc32(checked_header) != checksum:
                continue
            start, count, entry_size, checksum = struct.unpack_from("<QIII", header, 72)
            if not (0 < count <= 4096 and 128 <= entry_size <= 4096):
                continue
            source.seek(start * sector)
            entries = source.read(count * entry_size)
            if len(entries) != count * entry_size or zlib.crc32(entries) != checksum:
                continue
            for pos in range(0, len(entries), entry_size):
                entry = entries[pos:pos + entry_size]
                if entry[56:128].decode("utf-16le", errors="replace").split("\0", 1)[0] != name:
                    continue
                first, last = struct.unpack_from("<QQ", entry, 32)
                offset = first * sector
                size = (last - first + 1) * sector
                if size <= 0 or offset + size > image.stat().st_size:
                    raise ValueError(f"{image}: partition {name} is truncated")
                return offset, size
    raise ValueError(f"{image}: no {name} partition in a valid primary GPT")


def read_dtbs(image, offset=0):
    with image.open("rb") as source:
        source.seek(offset)
        header = source.read(44)
        if header[:8] != b"ANDROID!" or len(header) != 44:
            raise ValueError(f"{image}: expected an Android boot image")
        size = struct.unpack_from("<I", header, 8)[0]
        page_size = struct.unpack_from("<I", header, 36)[0]
        if not 0 < size <= 128 * 1024 * 1024 or page_size not in (2048, 4096, 8192, 16384):
            raise ValueError(f"{image}: invalid legacy boot image header")
        source.seek(offset + page_size)
        payload = source.read(size)
    if len(payload) != size or not payload.startswith(b"\x1f\x8b"):
        raise ValueError(f"{image}: expected a complete gzip kernel payload")
    kernel = zlib.decompressobj(31)
    kernel.decompress(payload)
    data = kernel.unused_data
    pos = 0
    count = 0
    while data[pos:pos + 4] == FDT_MAGIC:
        if len(data) - pos < 40:
            break
        size = struct.unpack_from(">I", data, pos + 4)[0]
        if size < 40 or pos + size > len(data):
            break
        pos += size
        count += 1
    if not kernel.eof or not count or pos != len(data):
        raise ValueError(f"{image}: invalid appended DTB bundle")
    print(f"Extracted {count} DTBs from {image.name}")
    return data


def system_image(image, raw):
    with image.open("rb") as source:
        sparse = source.read(4) == SPARSE_MAGIC
        source.seek(1024 + 56)
        ext4 = source.read(2) == b"\x53\xef"
    if ext4:
        return image
    if sparse:
        subprocess.run(["simg2img", str(image), str(raw)], check=True)
        return raw

    offset, remaining = partition(image, "system")
    with image.open("rb") as source, raw.open("wb") as dest:
        source.seek(offset)
        while remaining:
            chunk = source.read(min(remaining, 8 * 1024 * 1024))
            if not chunk:
                raise ValueError(f"{image}: truncated system partition")
            if chunk.count(0) == len(chunk):
                dest.seek(len(chunk), 1)
            else:
                dest.write(chunk)
            remaining -= len(chunk)
        dest.truncate()
    return raw


def extract_system(image, mappings, version, work, stage):
    system = system_image(image, work / "system.raw")
    props = subprocess.run(["debugfs", "-R", "cat /build.prop", str(system)],
                           capture_output=True, text=True, check=True).stdout.splitlines()
    if f"ro.build.version.release={version}" not in props:
        raise ValueError(f"{image}: expected a Butler Android {version} system image")
    requests = work / "debugfs.txt"
    requests.write_text("".join(f'dump {src} "{work / str(i)}"\n'
                                for i, (src, _) in enumerate(mappings)))
    subprocess.run(["debugfs", "-f", str(requests), str(system)],
                   stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, check=True)
    for i, (src, dest) in enumerate(mappings):
        blob = work / str(i)
        if not blob.is_file() or not blob.stat().st_size:
            raise ValueError(f"{image}: could not extract {src}")
        if dest.endswith("/WCNSS_qcom_cfg.ini"):
            data = blob.read_bytes()
            for old, new in ((b"gIPAConfig=0x1d", b"gIPAConfig=0x00"),
                             (b"IpaUcOffloadEnabled=1", b"IpaUcOffloadEnabled=0")):
                if old not in data and new not in data:
                    raise ValueError(f"{image}: unexpected WLAN configuration")
                data = data.replace(old, new)
            blob.write_bytes(data)
        target = stage / dest
        target.parent.mkdir(parents=True, exist_ok=True)
        blob.replace(target)
    print(f"Extracted {len(mappings)} Android {version} files from {image.name}")


def load_mappings(name, device):
    stock = "falcon" if device == "falkon" else "raptor"
    lines = (TOOLS / name).read_text().format(device=device, stock=stock).splitlines()
    return [line.split("\t") for line in lines]


def main():
    parser = argparse.ArgumentParser(description="Extract HP Butler LineageOS build inputs.")
    parser.add_argument("device", choices=("raptor", "falkon"))
    stock = parser.add_mutually_exclusive_group(required=True)
    stock.add_argument("--stock-dump", type=Path, help="Android 7.1.2 full GPT dump")
    stock.add_argument("--stock-system", type=Path, help="Android 7.1.2 system image")
    parser.add_argument("--stock-boot", type=Path, help="Android 7.1.2 boot image for --stock-system")
    parser.add_argument("--oreo", type=Path, required=True,
                        help="RAPTOR Android 8.1.0 system image or full GPT dump")
    parser.add_argument("--tree", type=Path, default=TOOLS.parents[2], help="LineageOS source root")
    args = parser.parse_args()
    if bool(args.stock_boot) != bool(args.stock_system):
        parser.error("--stock-boot and --stock-system must be used together")
    directory = args.tree.resolve() / "vendor/hp"
    directory.mkdir(parents=True, exist_ok=True)

    try:
        if args.stock_dump:
            boot_offset, _ = partition(args.stock_dump, "boot")
            dtbs = read_dtbs(args.stock_dump, boot_offset)
        else:
            dtbs = read_dtbs(args.stock_boot)
        with tempfile.TemporaryDirectory(prefix=".extract-", dir=directory) as temp:
            work = Path(temp)
            stage = work / "staged"
            output = stage / args.device / "proprietary/boot/stock-dtbs.bin"
            output.parent.mkdir(parents=True)
            output.write_bytes(dtbs)
            for name, image, version in (
                    ("nougat.tsv", args.stock_dump or args.stock_system, "7.1.2"),
                    ("butler-8.1.0.tsv", args.oreo, "8.1.0")):
                with tempfile.TemporaryDirectory(dir=work) as raw_dir:
                    extract_system(image, load_mappings(name, args.device),
                                   version, Path(raw_dir), stage)
            for blob in sorted(stage.rglob("*")):
                if blob.is_file():
                    dest = directory / blob.relative_to(stage)
                    dest.parent.mkdir(parents=True, exist_ok=True)
                    if not dest.is_file() or not filecmp.cmp(blob, dest, shallow=False):
                        blob.replace(dest)
    except (ValueError, OSError, zlib.error, subprocess.CalledProcessError) as error:
        parser.exit(1, f"{error}\n")


if __name__ == "__main__":
    main()
