#export THEOS=/home/codespace/theos/

TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = com.garena.game.kgvn

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PinkNotice

PinkNotice_FILES = Tweak.x
PinkNotice_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-error

PinkNotice_FRAMEWORKS = UIKit Foundation QuartzCore


include $(THEOS_MAKE_PATH)/tweak.mk
