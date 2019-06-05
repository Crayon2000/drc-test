DEVKITPRO=/opt/devkitpro
DEVKITPPC=/opt/devkitpro/devkitPPC
WUT_ROOT:=/opt/devkitpro/wut

BASEDIR	:= $(dir $(firstword $(MAKEFILE_LIST)))
VPATH	:= $(BASEDIR)

#---------------------------------------------------------------------------------
# additional libraries
#---------------------------------------------------------------------------------
#GET			:=	./libs/get/src
#RAPIDJSON	:=	./libs/get/src/libs/rapidjson/include
#MINIZIP		:=	./libs/get/src/libs/minizip
#TINYXML 	:=	libs/get/src/libs/tinyxml

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing header files
# ROMFS is a directory that will be available as romfs:/
#---------------------------------------------------------------------------------
TARGET		:=	drctest
BUILD		:=	build
SOURCES		:=	src
#. $(GET) console gui
INCLUDES	:=	include
#ROMFS		:=	romfs

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
CFLAGS		+=	-O2 -DUSE_FILE32API -DNOCRYPT -DINPUT_JOYSTICK -DMUSIC -D_XOPEN_SOURCE
CXXFLAGS	+=	-O2 -DUSE_FILE32API -DNOCRYPT -DINPUT_JOYSTICK -DMUSIC -D_XOPEN_SOURCE

#---------------------------------------------------------------------------------
# libraries
#---------------------------------------------------------------------------------
PKGCONF			:=	$(DEVKITPRO)/portlibs/ppc/bin/powerpc-eabi-pkg-config
PKGCONF_WIIU	:=	$(DEVKITPRO)/portlibs/wiiu/bin/powerpc-eabi-pkg-config
#CFLAGS			+=	`$(PKGCONF_WIIU) --cflags sdl2 SDL2_gfx SDL2_image SDL2_mixer SDL2_ttf`
#CXXFLAGS		+=	`$(PKGCONF_WIIU) --cflags sdl2 SDL2_gfx SDL2_image SDL2_mixer SDL2_ttf`
#LDFLAGS			+=	`$(PKGCONF_WIIU) --libs sdl2 SDL2_gfx SDL2_image SDL2_mixer SDL2_ttf` \
#					`$(PKGCONF) --libs freetype2 libpng libmpg123 vorbisidec libjpeg zlib libpng`

#---------------------------------------------------------------------------------
# wut libraries
#---------------------------------------------------------------------------------
LDFLAGS		+=	$(WUT_NEWLIB_LDFLAGS) $(WUT_STDCPP_LDFLAGS) $(WUT_DEVOPTAB_LDFLAGS) \
				-lcoreinit -lvpad -lsysapp -lwhb -lproc_ui\

#---------------------------------------------------------------------------------
# romfs
#---------------------------------------------------------------------------------
#include $(DEVKITPRO)/portlibs/wiiu/share/romfs-wiiu.mk
#CFLAGS		+=	$(ROMFS_CFLAGS)
#CXXFLAGS	+=	$(ROMFS_CFLAGS)
#LDFLAGS		+=	$(ROMFS_LDFLAGS)
#OBJECTS		+=	$(ROMFS_TARGET)

#---------------------------------------------------------------------------------
# includes
#---------------------------------------------------------------------------------
CFLAGS		+=	$(foreach dir,$(INCLUDES),-I$(dir))
CXXFLAGS	+=	$(foreach dir,$(INCLUDES),-I$(dir))

#---------------------------------------------------------------------------------
# generate a list of objects
#---------------------------------------------------------------------------------
CFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
SFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.S))
OBJECTS		+=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.S=.o)

#---------------------------------------------------------------------------------
# targets
#---------------------------------------------------------------------------------
$(TARGET).rpx: $(OBJECTS)

clean:
	$(info clean ...)
	@rm -rf $(TARGET).rpx $(OBJECTS) $(OBJECTS:.o=.d)

.PHONY: clean

#---------------------------------------------------------------------------------
# wut
#---------------------------------------------------------------------------------
include $(WUT_ROOT)/share/wut.mk