LOCAL_PATH := $(call my-dir)

# KonstaKANG apps + LineageOS Wraith overlays, imported presigned (keep original signatures).
# Regular apps go to priv-app dirs; RRO overlays go to product/overlay.

# DeviceSettings -> /system/priv-app
include $(CLEAR_VARS)
LOCAL_MODULE := DeviceSettings
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := DeviceSettings.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MODULE_PATH := $(TARGET_OUT_PRIV_APP)
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

# LineageCustomizer -> /product/priv-app
include $(CLEAR_VARS)
LOCAL_MODULE := LineageCustomizer
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := LineageCustomizer.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/priv-app
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

# Runtime Resource Overlays -> /product/overlay
define import-rro-overlay
include $$(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(1).apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/overlay
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
include $$(BUILD_PREBUILT)
endef

$(eval $(call import-rro-overlay,DocumentsUIOverlay))
$(eval $(call import-rro-overlay,NetworkStackOverlay))
$(eval $(call import-rro-overlay,PermissionControllerOverlay))
$(eval $(call import-rro-overlay,LineageGoogleSetupWraithOverlay))
$(eval $(call import-rro-overlay,LineageGoogleSetupWraithPairingOverlay))
