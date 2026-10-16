LOCAL_PATH := $(call my-dir)

# Bisect: ONLY DeviceSettings (the "Raspberry Pi settings" app), imported presigned.
# LineageCustomizer + 5 RRO overlays removed to isolate the boot hang.

# DeviceSettings -> /system/priv-app
include $(CLEAR_VARS)
LOCAL_MODULE := DeviceSettings
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := DeviceSettings.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MODULE_PATH := $(TARGET_OUT)/priv-app
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)
