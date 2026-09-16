APPLY_CUSTOM_FEATURE()
{
    local CONFIG_FILE="$1"
    local ERR_LABEL="$2"

    while read -r i; do
        [[ "$i" = "#"* ]] && continue
        [[ -z "$i" ]] && continue

        if echo -n "$i" | grep -q "="; then
            if [[ -z "$(echo -n "$i" | cut -d "=" -f 2)" ]]; then
                SET_FLOATING_FEATURE_CONFIG "$(echo -n "$i" | cut -d "=" -f 1)" --delete
            else
                SET_FLOATING_FEATURE_CONFIG "$(echo -n "$i" | cut -d "=" -f 1)" "$(echo -n "$i" | cut -d "=" -f 2-)"
            fi
        else
            LOGE "Malformed string in $ERR_LABEL: \"$i\""
        fi
    done < "$CONFIG_FILE"
}

if [ -f "$SRC_DIR/platform/$TARGET_PLATFORM/sff.sh" ]; then
    LOG_STEP_IN "- Applying custom platform floating feature config"
    APPLY_CUSTOM_FEATURE "$SRC_DIR/platform/$TARGET_PLATFORM/sff.sh" "platform/\"$TARGET_PLATFORM\"/sff.sh"
    LOG_STEP_OUT
fi

if [ -f "$SRC_DIR/target/$TARGET_CODENAME/sff.sh" ]; then
    LOG_STEP_IN "- Applying custom device floating feature config"
    APPLY_CUSTOM_FEATURE "$SRC_DIR/target/$TARGET_CODENAME/sff.sh" "target/\"$TARGET_CODENAME\"/sff.sh"
    LOG_STEP_OUT
fi

# Smart Tutor
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_SMARTTUTOR_PACKAGES_PATH" --delete

# Logging
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_CONTEXTSERVICE_ENABLE_SURVEY_MODE" --delete

# BlockchainTZService
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE" --delete
