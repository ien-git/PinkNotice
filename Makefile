# Chỉ định SDK và target (iOS 14.0 trở lên)
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

# Bundle ID của Liên Quân Mobile (Việt Nam) để tự động kill app khi cài đặt
INSTALL_TARGET_PROCESSES = com.garena.game.kgvn

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PinkNotice

# Các file mã nguồn
PinkNotice_FILES = Tweak.x
PinkNotice_CFLAGS = -fobjc-arc
# Import thư viện giao diện
PinkNotice_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
