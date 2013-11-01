OUT = pdfviewer

VPATH = src cimages
SOURCES = main.cpp display.cpp MySplashOutputDev.cpp SearchOutputDev.cpp images.c zoom.cpp area.cpp
INCLUDES = -Ipoppler/poppler -Ipoppler/goo -Ipoppler
LIBS = -lfreetype -lfontconfig -ljpeg

VPATH += poppler/goo poppler/fofi poppler/splash poppler/poppler
SOURCES += $(notdir $(wildcard poppler/goo/*.cc poppler/fofi/*.cc poppler/splash/*.cc poppler/poppler/*.cc))

CXXFLAGS += -fno-exceptions -fno-check-new -fno-common

ifeq ($(BUILD), arm)
CXXFLAGS += -DLLONG_MAX=LONG_MAX
LDFLAGS += -Wl,-rpath,/mnt/ext1/system/lib
endif

ifeq ($(BUILD), arm)
PBFRAMEWORK =
else
PBFRAMEWORK = 11
endif

ifneq ($(PBFRAMEWORK),)
SOURCES += pbmainframe.cpp pbtouchzoomdlg.cpp pbpagehistorynavigation.cpp
CXXFLAGS += -DPBFRAMEWORK=$(PBFRAMEWORK) -DPLATFORM_FC
LIBS += -lpbframework -lbookstate
ifeq ($(BUILD), arm_gnueabi)
LIBS += -lcrypto
endif
endif

include /usr/local/pocketbook/common.mk

ifneq ($(DIST),)
ifneq ($(BUILD),)
ZIP = $(OUT)-$(BUILD).zip
all: $(ZIP)
endif
endif

$(ZIP): $(PROJECT)
	rm -rf system
	mkdir -p system/bin
	cp -p $(PROJECT) system/bin
ifeq ($(BUILD), arm)
	mkdir -p system/lib
	cp -p /usr/arm-linux/lib/libfontconfig.so.1 system/lib
endif
	mkdir -p system/fonts/pdf
	cp -p fonts.conf system/fonts/pdf
	zip -r $(ZIP) system
