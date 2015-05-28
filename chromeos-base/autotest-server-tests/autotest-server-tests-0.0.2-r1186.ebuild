# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="0942bbc1f149b00a05920bc4e23064c6ea86d985"
CROS_WORKON_TREE="2b04f9094009432e112fa1e203f87ac17ea9656e"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest
CROS_WORKON_SUBDIR=files

inherit cros-workon autotest

DESCRIPTION="Autotest server tests"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Enable autotest by default.
IUSE="-app_shell +autotest +cellular -chromeless_tty cros_p2p debugd -moblab +power_management +readahead +tpm"

RDEPEND=""
DEPEND="${RDEPEND}
	!<chromeos-base/autotest-0.0.2
"

SERVER_IUSE_TESTS="
	+tests_audio_AudioBasicHDMI
	+tests_audio_AudioBasicHeadphone
	+tests_autoupdate_CatchBadSignatures
	+tests_autoupdate_Rollback
	cellular? ( +tests_cellular_StaleModemReboot )
	debugd? ( +tests_debugd_DevTools )
	!chromeless_tty? (
		!app_shell? (
			+tests_desktopui_CrashyRebootServer
		)
	)
	+tests_display_EdidStress
	+tests_display_EndToEnd
	+tests_display_HDCPScreen
	+tests_display_HotPlugAtBoot
	+tests_display_HotPlugAtSuspend
	+tests_display_HotPlugNoisy
	+tests_display_LidCloseOpen
	+tests_display_NoEdid
	+tests_display_Resolution
	+tests_display_ResolutionList
	+tests_display_ServerChameleonConnection
	+tests_display_SuspendStress
	+tests_display_SwitchMode
	+tests_dummy_PassServer
	+tests_dummy_FailServer
	+tests_dummy_FlakyTestServer
	+tests_enterprise_RemoraRequisitionServer
	+tests_factory_Basic
	+tests_firmware_CgptState
	+tests_firmware_CgptStress
	+tests_firmware_CompareInstalledToShellBall
	+tests_firmware_ConsecutiveBoot
	+tests_firmware_CorruptBothFwBodyAB
	+tests_firmware_CorruptBothFwSigAB
	+tests_firmware_CorruptBothKernelAB
	+tests_firmware_CorruptFwBodyA
	+tests_firmware_CorruptFwBodyB
	+tests_firmware_CorruptFwSigA
	+tests_firmware_CorruptFwSigB
	+tests_firmware_CorruptKernelA
	+tests_firmware_CorruptKernelB
	+tests_firmware_DevBootUSB
	+tests_firmware_DevMode
	+tests_firmware_DevModeStress
	+tests_firmware_DevScreenTimeout
	+tests_firmware_DevTriggerRecovery
	+tests_firmware_ECBattery
	+tests_firmware_ECBootTime
	+tests_firmware_ECCharging
	+tests_firmware_ECHash
	+tests_firmware_ECKeyboard
	+tests_firmware_ECLidSwitch
	+tests_firmware_ECPeci
	+tests_firmware_ECPowerButton
	+tests_firmware_ECPowerG3
	+tests_firmware_ECSharedMem
	+tests_firmware_ECThermal
	+tests_firmware_ECUsbPorts
	+tests_firmware_ECWakeSource
	+tests_firmware_ECWatchdog
	+tests_firmware_ECWriteProtect
	+tests_firmware_EventLog
	+tests_firmware_FAFTPrepare
	+tests_firmware_FAFTSetup
	+tests_firmware_FwScreenCloseLid
	+tests_firmware_FwScreenPressPower
	+tests_firmware_InvalidUSB
	+tests_firmware_LegacyRecovery
	+tests_firmware_Mosys
	+tests_firmware_RecoveryButton
	+tests_firmware_RollbackFirmware
	+tests_firmware_RollbackKernel
	+tests_firmware_RONormalBoot
	+tests_firmware_SelfSignedBoot
	+tests_firmware_SoftwareSync
	tpm? ( +tests_firmware_TPMExtend )
	tpm? ( +tests_firmware_TPMVersionCheck )
	+tests_firmware_TryFwB
	+tests_firmware_UpdateECBin
	+tests_firmware_UpdateFirmwareDataKeyVersion
	+tests_firmware_UpdateFirmwareVersion
	+tests_firmware_UpdateKernelDataKeyVersion
	+tests_firmware_UpdateKernelSubkeyVersion
	+tests_firmware_UpdateKernelVersion
	+tests_firmware_UserRequestRecovery
	+tests_graphics_PowerConsumption
	+tests_hardware_DiskFirmwareUpgrade
	+tests_hardware_MemoryIntegrity
	+tests_hardware_StorageQualBase
	+tests_hardware_StorageQualSuspendStress
	+tests_hardware_StorageQualTrimStress
	+tests_hardware_StorageStress
	+tests_kernel_EmptyLines
	+tests_kernel_ExternalUsbPeripheralsDetectionTest
	+tests_kernel_MemoryRamoop
	moblab? ( +tests_moblab_RunSuite )
	cros_p2p? ( +tests_p2p_EndToEndTest )
	+tests_network_FirewallHolePunchServer
	+tests_platform_BootDevice
	+tests_platform_BootPerfServer
	+tests_platform_CompromisedStatefulPartition
	+tests_platform_CorruptRootfs
	+tests_platform_CrashStateful
	+tests_platform_ExternalUsbPeripherals
	+tests_platform_HWwatchdog
	+tests_platform_InstallTestImage
	+tests_platform_KernelErrorPaths
	power_management? (
		+tests_platform_PowerStatusStress
		+tests_power_DarkResumeShutdownServer
		+tests_power_DeferForFlashrom
		+tests_power_SuspendShutdown
	)
	+tests_platform_Powerwash
	+tests_platform_RebootAfterUpdate
	+tests_platform_ServoPowerStateController
	+tests_platform_SyncCrash
	readahead? ( +tests_platform_UReadAheadServer )
	+tests_platform_Vpd
	+tests_power_RPMTest
	+tests_provision_AutoUpdate
	+tests_security_kASLR
	+tests_sequences
	+tests_video_PowerConsumption
	+tests_video_VimeoVideoWPR
"

IUSE_TESTS="${IUSE_TESTS}
	${SERVER_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_configure() {
	cros-workon_src_configure
}


