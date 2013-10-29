OUT = pdfviewer

VPATH = src cimages
SOURCES = main.cpp display.cpp MySplashOutputDev.cpp SearchOutputDev.cpp images.c zoom.cpp area.cpp
INCLUDES = -Ipoppler/poppler -Ipoppler/goo -Ipoppler
LIBS = -lfreetype -lfontconfig -ljpeg

VPATH += poppler/goo poppler/fofi poppler/splash poppler/poppler
SOURCES += $(notdir $(wildcard poppler/goo/*.cc poppler/fofi/*.cc poppler/splash/*.cc poppler/poppler/*.cc))

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
endif

include /usr/local/pocketbook/common.mk
