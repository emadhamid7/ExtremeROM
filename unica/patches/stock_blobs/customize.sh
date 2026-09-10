SOURCE_FIRMWARE_PATH="$FW_DIR/$(echo -n "$SOURCE_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"

LOG_STEP_IN "- Replacing boot animation blobs with stock"
BLOBS_LIST="
system/media/battery_error.spi
system/media/battery_lightning_fast.spi
system/media/battery_lightning.spi
system/media/battery_low.spi
system/media/battery_temperature_error.spi
system/media/battery_temperature_limit.spi
system/media/battery_water_usb.spi
system/media/bootsamsungloop.qmg
system/media/bootsamsung.qmg
system/media/charging_vi_100.spi
system/media/charging_vi_level1.spi
system/media/charging_vi_level2.spi
system/media/charging_vi_level3.spi
system/media/charging_vi_level4.spi
system/media/dock_error_usb.spi
system/media/incomplete_connect.spi
system/media/lcd_density.txt
system/media/percentage.spi
system/media/safety_timer_usb.spi
system/media/shutdown.qmg
system/media/slow_charging_usb.spi
system/media/temperature_limit_usb.spi
system/media/water_protection_usb.spi
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "$blob" 0 0 644 "u:object_r:system_file:s0"
done
LOG_STEP_OUT

LOG_STEP_IN "- Replacing saiv blobs"
DELETE_FROM_WORK_DIR "system" "system/saiv"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/saiv" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/saiv/face"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/saiv/face" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/saiv/textrecognition"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/saiv/textrecognition" 0 0 755 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Replacing cameradata blobs"
DELETE_FROM_WORK_DIR "system" "system/cameradata"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/cameradata" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/cameradata/preloadfilters"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/cameradata/preloadfilters" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/cameradata/myfilter"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/cameradata/myfilter" 0 0 755 "u:object_r:system_file:s0"
LOG_STEP_OUT

if [ -f "$TARGET_FIRMWARE_PATH/system/system/usr/share/alsa/alsa.conf" ]; then
    LOG_STEP_IN "- Replacing alsa.conf"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/usr/share/alsa/alsa.conf" 0 0 644 "u:object_r:system_file:s0"
    LOG_STEP_OUT
fi

LOG_STEP_IN "- Replacing gamebooster props"
SET_PROP "product" "ro.gfx.driver.0" "$(GET_PROP "$WORK_DIR/vendor/build.prop" "ro.gfx.driver.0")"
SET_PROP "product" "ro.gfx.driver.1" "$(GET_PROP "$WORK_DIR/vendor/build.prop" "ro.gfx.driver.1")"
LOG_STEP_OUT

if [[ "$SOURCE_PRODUCT_FIRST_API_LEVEL" -gt 33 && "$TARGET_PRODUCT_FIRST_API_LEVEL" -le 33 ]]; then
    LOG_STEP_IN "- Downgrading VaultKeeper JNI"
    DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.vaultkeeper-V1-ndk.so"
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/libvkjni.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/libvkmanager.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/vendor.samsung.hardware.security.vaultkeeper@2.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
    LOG_STEP_OUT

    LOG_STEP_IN "- Downgrading ENGMODE JNI"
    DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.engmode-V1-ndk.so"
    ADD_TO_WORK_DIR "r11sxxx" "system" "lib64/lib.engmode.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "lib64/lib.engmodejni.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "lib64/vendor.samsung.hardware.security.engmode@1.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
    LOG_STEP_OUT
fi
