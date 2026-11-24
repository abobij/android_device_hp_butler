ifeq ($(TARGET_PRODUCT),lineage_raptor)
# The audio service probes stale 4.0 implementations before the stock HAL's 2.0 wrapper.
$(call add-clean-step, rm -f $(TARGET_OUT_VENDOR)/lib/hw/android.hardware.audio@4.0-impl.so $(TARGET_OUT_VENDOR)/lib/hw/android.hardware.audio.effect@4.0-impl.so)
endif
