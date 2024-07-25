export TARGET = iphone:clang:latest:16.0
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard MediaRemoteUI

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MusicPlayerControlsColor

MusicPlayerControlsColor_FILES = Tweak.x Utils.m
MusicPlayerControlsColor_LIBRARIES = gcuniversal
MusicPlayerControlsColor_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += musicplayercontrolscolorsettings
include $(THEOS_MAKE_PATH)/aggregate.mk
