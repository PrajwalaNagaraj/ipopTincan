CC = clang++

DEBUG ?= 0
ifeq ($(DEBUG), 1)
    OPT = debug
    cflags_cc = -O0
else
	OPT = release
    cflags_cc = -O3
endif

ARCH = $(shell uname -m)

INC_DIR = ../include
INC_DIR_LNX = $(INC_DIR)/linux
EXT_INC_DIR = ../../external/include 
RTC_INC_DIR = ../../external/include/webrtc

SRC_DIR = ../src
SRC_DIR_LNX = $(SRC_DIR)/linux

EXT_LIB_DIR = ../../external/3rd-Party-Libs/$(OPT)
OUT = ../out
OBJ_DIR = $(OUT)/$(OPT)/$(ARCH)/obj
BIN_DIR = $(OUT)/$(OPT)/$(ARCH)

BINARY = ipop-tincan
TARGET = $(patsubst %,$(BIN_DIR)/%,$(BINARY))

defines = -DLINUX -D_IPOP_LINUX -DWEBRTC_POSIX -DWEBRTC_LINUX -D_GLIBCXX_USE_CXX11_ABI=0 

cflags_cc += -std=c++14 --stdlib=libc++ -pthread -g2 -gsplit-dwarf -fno-strict-aliasing --param=ssp-buffer-size=4 -fstack-protector -funwind-tables -fPIC -pipe -Wall -fno-rtti
#-stdlib=libc++ -nodefaultlibs
LIBS = -nodefaultlibs -lc++ -lc++abi -lm -lc -lgcc_s -lgcc -ljsoncpp -lrtc_p2p -lrtc_base -llogging -lrtc_event -lrtc_base_approved -lboringssl -lboringssl_asm -lprotobuf_lite -lpthread -lutil -lstringutils -lchecks -lcriticalsection -lfield_trial -lfield_trial_parser -lice_log -llibjingle_peerconnection_api -lmetrics -loptions -lplatform_thread_types -lrtc_error -lrtc_pc_base -lsequence_checker -lstrings -lstun -ltimeutils -lweak_ptr -lsent_packet -lrtc_numerics -lthrow_delegate -lbase64 -lbad_optional_access -lmedia_transport_interface -lplatform_thread -lrtc_event_log -lrtc_media_base -lrtc_numerics -lrtp_parameters -lrtp_receiver -lrtp_rtcp_format -lthrow_delegate -lsrtp 
#-ltask_queue -lfile_wrapper -lyield_policy 
#-lbad_optional_access -lbase64 -lmedia_transport_interface -lplatform_thread -lrtc_event_log -lrtc_media_base -lrtc_numerics -lrtp_parameters -lrtp_receiver -lrtp_rtcp_format -lsent_packet -ltask_queue -lthrow_delegate -lweak_ptr -lyield_policy

HDR_FILES = $(wildcard $(INC_DIR)/*.h)
SRC_FILES = $(wildcard $(SRC_DIR)/*.cc)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.cc, $(OBJ_DIR)/%.o, $(SRC_FILES))

LSRC_FILES = $(wildcard $(SRC_DIR_LNX)/*.cc)
LOBJ_FILES = $(patsubst $(SRC_DIR_LNX)/%.cc, $(OBJ_DIR)/%.o, $(LSRC_FILES))
