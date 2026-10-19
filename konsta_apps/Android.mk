LOCAL_PATH := $(call my-dir)

# DeviceSettings -> /system/priv-app
# APK is re-signed with the AOSP platform test key (sharedUserId=android.uid.system), and its
# Settings tile category is patched ia.system -> ia.device so the Android TV Settings app
# ("Device preferences") can render it; the phone-only ia.system category is not shown on TV.
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

# LineageCustomizer (org.lineageos.tvcustomizer) -> /product/priv-app
# No sharedUserId and no privileged permissions: ships presigned with its LineageOS key.
include $(CLEAR_VARS)
LOCAL_MODULE := LineageCustomizer
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := LineageCustomizer.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/priv-app
LOCAL_PRIVILEGED_MODULE := true
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)
