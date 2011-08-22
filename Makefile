GO_EASY_ON_ME=1
THEOS_DEVICE_IP=192.168.1.104
SDKVERSION = 4.3

include theos/makefiles/common.mk

TWEAK_NAME = caffeine2
caffeine2_FILES = Tweak.xm
caffeine2_FRAMEWORKS = UIKit
caffeine2_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
