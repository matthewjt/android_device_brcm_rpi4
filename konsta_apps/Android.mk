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

# KangTvSettingsTwoPanel: MOVED to Android.bp (soong prebuilt_apk +
# soong_override_module). The kati BUILD_PREBUILT route could not remove the stock
# com.android.tv.settings apps (attempt 6: kati filter-out provably cannot touch
# packages appended by inherited products) -> soong override replaces them.

# SSH infrastructure (KonstaKANG's OpenSSH stack) -> /system (user request 2026-10-22).
# Toggle: DeviceSettings "SSH" switch sets persist.sshd.enabled (app side, baked).
# sshd.rc (copied to /system/etc/init): creates /data/ssh on post-fs-data, starts the
# sshd service on boot_completed && persist.sshd.enabled=1, stops it on =0.
# sshd service runs start-ssh: generates host keys in /data/ssh, seeds authorized_keys,
# seeds /data/ssh/sshd_config from /system/etc/ssh, then execs sshd -f ... -D (no-fork).
# Binary deps (libcrypto/libssl/libz/libcutils/libc++) are all AOSP-built system libs.
include $(CLEAR_VARS)
LOCAL_MODULE := sshd_bin
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := ssh/sshd
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
LOCAL_MODULE_STEM := sshd
LOCAL_MULTILIB := 64
LOCAL_SHARED_LIBRARIES := libcrypto libssl libz libcutils libssh
LOCAL_INIT_RC := ssh/sshd.rc
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ssh_client
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := ssh/ssh
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
LOCAL_MODULE_STEM := ssh
LOCAL_MULTILIB := 64
LOCAL_SHARED_LIBRARIES := libcrypto libssl libz libssh
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ssh_keygen
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := ssh/ssh-keygen
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
LOCAL_MODULE_STEM := ssh-keygen
LOCAL_MULTILIB := 64
LOCAL_SHARED_LIBRARIES := libcrypto libssl libz libssh
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libssh
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := ssh/libssh.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MULTILIB := 64
LOCAL_SHARED_LIBRARIES := libcrypto libssl libz
include $(BUILD_PREBUILT)
