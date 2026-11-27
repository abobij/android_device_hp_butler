# LineageOS 17.1 for HP Pro/Elite X3 (Butler)
Based on stock 7.1.2 (falkon/raptor) and 8.1.0 (raptor)

## Supported devices

* **falkon** - HP Elite x3 (Retail, [converted to android 7.1.2](https://xdaforums.com/t/guide-how-to-install-android-to-hp-elite-x3.4565837/))
* **raptor** - HP Pro x3 (Prototype, unreleased, ABU variant)

## Status

|      Feature      | raptor | falkon |                            Note                            |
| :---------------: | :----: | :----: | :--------------------------------------------------------: |
|       Boot        |   ✅    |   ✅    |               Boots with display and touch.                |
|      Wifi/BT      |   ✅    |   ✅    |                                                            |
|       Audio       |   ✅    |   ✅    |            Main Speaker, Mic, 3.5mm Jack, A2DP             |
|        RIL        |   ✅    |   ❓    |       Dual-SIM works on `raptor` (SIM2 IMEI Unknown)       |
|     Keystore      |   ✅    |   ❓    |                                                            |
|    Encryption     |   ⚠️   |   ⚠️   |                      Disabled for now                      |
|      USB ADB      |   ✅    |   ✅    |                                                            |
|      USB OTG      |   ❓    |   ✅    |                                                            |
|      USB MTP      |   ✅    |   ❓    |                                                            |
|   Camera/Torch    |   ✅    |   ✅    |             Buggy app, no video recording yet.             |
|    Fingerprint    |   ⚠️   |   ⚠️   |                                                            |
|  IR Front Camera  |  N/A   |   ⚠️   |                `falkon` only. Not planned.                 |
| SELinux Enforcing |   ⚠️   |   ⚠️   |                      Disabled for now                      |
|      Sensors      |   ✅    |   ❓    |  42 SLPI sensors & auto-rotate on raptor; falkon untested  |
|       GNSS        |   ✅    |   ❓    |   Multi-constellation 3D fix on `raptor`; `falkon` untested   |
|        NFC        |   ⚠️   |   ⚠️   |                                                            |
|      microSD      |   ⚠️   |   ⚠️   |                                                            |
|      Haptics      |   ✅    |   ✅    |                                                            |
| Notification LED  |   ✅    |   ❓    |                                                            |
|    DP Alt-mode    |   ❓    |   ❓    |                                                            |
| Wireless Charging |  N/A   |   ❓    |                  `falkon` only. Untested                   |
|     Charging      |   ✅    |   ✅    |            Offline charging hangs on bootlogo.             |

## TODO

* Fix camera app hangs and exposure problems.
* Bring up everything.
* Enable stereo on `falkon`.
* Use own DTS instead of stock ones.
* Fix SELinux and FDE.

Thanks to [Computershik73](https://github.com/Computershik73) for testing `falkon`