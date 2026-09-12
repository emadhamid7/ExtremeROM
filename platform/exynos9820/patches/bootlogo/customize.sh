LOG_STEP_IN "- Adding custom up_param."
cp -a "$SRC_DIR/platform/exynos9820/patches/bootlogo/up_param_${TARGET_CODENAME}.bin" "$WORK_DIR/up_param.bin"
LOG_STEP_OUT