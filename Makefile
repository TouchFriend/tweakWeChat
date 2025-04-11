TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = tweakWeChat

tweakWeChat_FILES = src/Tweak.x src/models/*.m 
# tweakWeChat_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
