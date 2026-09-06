LOG_STEP_IN "- Patching APKs for network speed monitoring"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"
DECODE_APK "system_ext" "priv-app/SystemUI/SystemUI.apk"

FTP="
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/eternal/provider/items/NotificationsItem.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/notification/ConfigureNotificationMoreSettings\$1.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/notification/StatusBarNetworkSpeedController.smali
system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/Rune.smali
system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/QpRune.smali
"
for f in $FTP; do
    sed -i "s/CscFeature_Common_SupportZProjectFunctionInGlobal/CscFeature_Setting_SupportRealTimeNetworkSpeed/g" "$APKTOOL_DIR/$f"
done
LOG_STEP_OUT
