if [[ "$TARGET_NFC_CHIP_VENDOR" == "$SOURCE_NFC_CHIP_VENDOR" ]]; then
    LOG "- Target and source NFC chip vendor match ($TARGET_NFC_CHIP_VENDOR). Nothing to do."

elif [[ "$TARGET_NFC_CHIP_VENDOR" == "SLSI" && "$SOURCE_NFC_CHIP_VENDOR" == "NXP" ]]; then
    LOG "- Target NFC is SLSI, source is NXP. Swapping to SLSI blobs from r11sxxx."

    BLOBS_LIST="
    system/lib64/libnfc_nxpsn_jni.so
    system/lib64/vendor.samsung.hardware.nfc_aidl-V1-ndk.so
    system/lib64/vendor.samsung.hardware.nfc@2.0.so
    system/priv-app/NfcNci/lib/arm64/libnfc_nxpsn_jni.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    system/etc/libnfc-nci.conf
    system/lib64/libnfc_sec_jni.so
    system/lib64/libnfc-nci_flags.so
    system/lib64/libnfc-sec.so
    system/lib64/libstatslog_nfc.so
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "r11sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done

    ln -sf "/system/lib64/libnfc_sec_jni.so" "$WORK_DIR/system/system/priv-app/NfcNci/lib/arm64/libnfc_sec_jni.so"
    SET_METADATA "system" "system/priv-app/NfcNci/lib/arm64/libnfc_sec_jni.so" 0 0 644 "u:object_r:system_file:s0"

elif [[ "$TARGET_NFC_CHIP_VENDOR" == "NXP" && "$SOURCE_NFC_CHIP_VENDOR" == "SLSI" ]]; then
    LOG "- Target NFC is NXP, source is SLSI. Swapping to NXP blobs from pa3qzcx."

    BLOBS_LIST="
    system/lib64/libnfc_sec_jni.so
    system/lib64/libnfc-nci_flags.so
    system/lib64/libnfc-sec.so
    system/lib64/libstatslog_nfc.so
    system/priv-app/NfcNci/lib/arm64/libnfc_sec_jni.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    system/etc/libnfc-nci.conf
    system/lib64/libnfc_nxpsn_jni.so
    system/lib64/vendor.samsung.hardware.nfc_aidl-V1-ndk.so
    system/lib64/vendor.samsung.hardware.nfc@2.0.so
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "pa3qzcx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done

    ln -sf "/system/lib64/libnfc_nxpsn_jni.so" "$WORK_DIR/system/system/priv-app/NfcNci/lib/arm64/libnfc_nxpsn_jni.so"
    SET_METADATA "system" "system/priv-app/NfcNci/lib/arm64/libnfc_nxpsn_jni.so" 0 0 644 "u:object_r:system_file:s0"

else
    LOG "- Unhandled NFC chip vendor combination (target: $TARGET_NFC_CHIP_VENDOR, source: $SOURCE_NFC_CHIP_VENDOR). Ignoring."
fi