LOG_STEP_IN "- Replacing camera blobs"
BLOBS_LIST="
system/lib64/libdualcam_refocus_gallery_54.so
system/lib64/libdualcam_refocus_gallery_50.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob" &
done

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

BLOBS_LIST="
system/lib64/libPortraitDistortionCorrectionCali.arcsoft.so
system/lib64/libMultiFrameProcessing10.camera.samsung.so
system/lib64/libMultiFrameProcessing20.camera.samsung.so
system/lib64/libMultiFrameProcessing20Day.camera.samsung.so
system/lib64/libMultiFrameProcessing30.camera.samsung.so
system/lib64/libMultiFrameProcessing30Tuning.camera.samsung.so
system/lib64/vendor.samsung_slsi.hardware.iva@1.0.so
system/lib64/vendor.samsung_slsi.hardware.MultiFrameProcessing20@1.0.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0" &
done

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

LOG_STEP_OUT

LOG_STEP_IN "- Removing HDR10+ check"
HEX_PATCH "$WORK_DIR/system/system/lib64/libstagefright.so" "010140f9cf390594a0500034" "010140f91f2003d51f2003d5"
LOG_STEP_OUT

LOG_STEP_IN "- Adding SWISP models"
DELETE_FROM_WORK_DIR "vendor" "saiv/swisp_1.0"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "saiv/swisp_1.0"
LOG_STEP_OUT

LOG_STEP_IN "- Cleaning SamsungCamera OAT"
DELETE_FROM_WORK_DIR "system" "system/priv-app/SamsungCamera/SamsungCamera.apk.prof"
LOG_STEP_OUT

LOG_STEP_IN "- Adding SingleTake models"
DELETE_FROM_WORK_DIR "vendor" "etc/singletake"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "etc/singletake"

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

LOG "- Decompiling SamsungCamera" # To fool build system into recompiling + signing it at the end
DECODE_APK "system" "system/priv-app/SamsungCamera/SamsungCamera.apk"

if [[ "$TARGET_CODENAME" == "beyond2lte" ]]; then
    LOG "- Adding stock cutout assets"
    cp -a "$MODPATH/assets/lottie_camera_punchcut_timer_b2.json" "$APKTOOL_DIR/system/priv-app/SamsungCamera/SamsungCamera.apk/res/raw/lottie_camera_punchcut_timer_b0.json"
    cp -a "$MODPATH/assets/face_unlocking_cutout_ic_b2.json" "$APKTOOL_DIR/system/priv-app/SamsungCamera/SamsungCamera.apk/res/raw/face_unlocking_cutout_ic_b0.json"
fi

if [[ "$TARGET_CODENAME" == "beyondx" ]]; then
    LOG "- Adding stock cutout assets"
    cp -a "$MODPATH/assets/lottie_camera_punchcut_timer_bx.json" "$APKTOOL_DIR/system/priv-app/SamsungCamera/SamsungCamera.apk/res/raw/lottie_camera_punchcut_timer_b0.json"
    cp -a "$MODPATH/assets/face_unlocking_cutout_ic_bx.json" "$APKTOOL_DIR/system/priv-app/SamsungCamera/SamsungCamera.apk/res/raw/face_unlocking_cutout_ic_b0.json"
fi

LOG_STEP_OUT
