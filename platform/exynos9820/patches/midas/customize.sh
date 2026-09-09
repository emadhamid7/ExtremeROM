LOG_STEP_IN "- Adding S21 (p3sxxx) Ultra MIDAS"
DELETE_FROM_WORK_DIR "vendor" "etc/midas"
DELETE_FROM_WORK_DIR "vendor" "etc/VslMesDetector"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "etc/midas"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE" "vendor" "etc/VslMesDetector"
LOG_STEP_OUT

LOG "- Fixing MIDAS model detection"
sed -i "s/$SOURCE_CODENAME/dummy/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
sed -i "s/p3s/$SOURCE_CODENAME/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
