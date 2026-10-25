#!/system/bin/sh
# LineageOS normally seeds the "advanced_reboot" Secure default from its framework
# (LineageSettingsProvider defaults path). We run AOSP framework, so seed it here:
# KangTvSettingsTwoPanel's RebootConfirmFragment only renders the
# "Restart to recovery" button when secure/advanced_reboot == 1.
# Idempotent: re-put every boot. Runs in su domain (seclabel in lineage_seeder.rc).
settings put secure advanced_reboot 1
