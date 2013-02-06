include theos/makefiles/common.mk

TWEAK_NAME = caffeine2
caffeine2_FILES = Tweak.xm
caffeine2_FRAMEWORKS = UIKit
caffeine2_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
