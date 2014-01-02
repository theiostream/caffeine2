TARGET = ::4.3
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = caffeine2
caffeine2_FILES = Tweak.xm
caffeine2_FRAMEWORKS = UIKit
caffeine2_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
