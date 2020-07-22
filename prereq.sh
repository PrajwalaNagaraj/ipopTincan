#!/bin/bash
#Ensure git works in the setup
#steps to install webrtc M84[4147] version for release build
sudo apt-get update && sudo apt-get -y install git python
mkdir -p ~/workspace/ && cd ~/workspace/
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=`pwd`/depot_tools:"$PATH"
mkdir webrtc-checkout
cd webrtc-checkout
fetch --nohooks webrtc
cd src
git checkout branch-heads/4147
gclient sync
sudo apt-get install gtk2.0
gn gen out/release "--args=enable_iterator_debugging=false is_component_build=false is_debug=false"
ninja -C out/release/ 
#steps to build ipop by adding the required libraries
cd ../..
sudo apt update -y
sudo apt install -y git make libssl-dev g++-5 python3 python3-pip python3-dev openvswitch-switch iproute2 bridge-utils
sudo -H python3 -m pip install --upgrade pip
sudo -H python3 -m pip --no-cache-dir install psutil==5.6.3 sleekxmpp==1.3.3 requests==2.21.0 simplejson==3.16.0 ryu==4.30
mkdir -p ~/workspace/ipop-project/ipop-vpn/config
cd ~/workspace/ipop-project/
git clone https://github.com/ipop-project/Tincan
cd ../..
mkdir -p ipop-project/Tincan/external/3rd-Party-Libs/release ipop-project/Tincan/external/3rd-Party-Libs/debug
#getting the required .o files and .a files to 3rd party libs from webrtc-checkout
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libboringssl_asm.a webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/aes128gcmsiv-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/aesni-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/vpaes-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/rsaz-avx2.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/x86_64-mont.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/x86_64-mont5.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/chacha-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/p256-x86_64-asm.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/md5-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/aesni-gcm-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/ghash-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/rdrand-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/sha1-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/sha256-x86_64.o webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl_asm/sha512-x86_64.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libjsoncpp.a webrtc-checkout/src/out/release/obj/third_party/jsoncpp/jsoncpp/json_reader.o webrtc-checkout/src/out/release/obj/third_party/jsoncpp/jsoncpp/json_value.o webrtc-checkout/src/out/release/obj/third_party/jsoncpp/jsoncpp/json_writer.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libboringssl.a webrtc-checkout/src/out/release/obj/third_party/boringssl/boringssl/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_base.a webrtc-checkout/src/out/release/obj/rtc_base/rtc_base/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_base_approved.a webrtc-checkout/src/out/release/obj/rtc_base/rtc_base_approved/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_p2p.a webrtc-checkout/src/out/release/obj/p2p/rtc_p2p/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libprotobuf_lite.a webrtc-checkout/src/out/release/obj/third_party/protobuf/protobuf_lite/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/liblogging.a webrtc-checkout/src/out/release/obj/rtc_base/logging/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_event.a webrtc-checkout/src/out/release/obj/rtc_base/rtc_event/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libstringutils.a webrtc-checkout/src/out/release/obj/rtc_base/stringutils/*.o
ar -rcs ipop-project//Tincan/external/3rd-Party-Libs/release/libtimeutils.a webrtc-checkout/src/out/release/obj/rtc_base/timeutils/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libplatform_thread_types.a webrtc-checkout/src/out/release/obj/rtc_base/platform_thread_types/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libcriticalsection.a webrtc-checkout/src/out/release/obj/rtc_base/criticalsection/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/liboptions.a webrtc-checkout/src/out/release/obj/api/crypto/options/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libsequence_checker.a webrtc-checkout/src/out/release/obj/rtc_base/sequence_checker/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_pc_base.a webrtc-checkout/src/out/release/obj/pc/rtc_pc_base/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libchecks.a webrtc-checkout/src/out/release/obj/rtc_base/checks/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libmetrics.a webrtc-checkout/src/out/release/obj/system_wrappers/metrics/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libfield_trial.a webrtc-checkout/src/out/release/obj/system_wrappers/field_trial/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libice_log.a webrtc-checkout/src/out/release/obj/logging/ice_log/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libfield_trial_parser.a webrtc-checkout/src/out/release/obj/rtc_base/experiments/field_trial_parser/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libstun.a webrtc-checkout/src/out/release/obj/api/transport/stun_types/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/liblibjingle_peerconnection_api.a webrtc-checkout/src/out/release/obj/api/libjingle_peerconnection_api/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libstrings.a webrtc-checkout/src/out/release/obj/third_party/abseil-cpp/absl/strings/strings/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libweak_ptr.a webrtc-checkout/src/out/release/obj/rtc_base/weak_ptr/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libsent_packet.a webrtc-checkout/src/out/release/obj/rtc_base/network/sent_packet/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_numerics.a webrtc-checkout/src/out/release/obj/rtc_base/rtc_numerics/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libthrow_delegate.a webrtc-checkout/src/out/release/obj/third_party/abseil-cpp/absl/base/throw_delegate/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libbase64.a webrtc-checkout/src/out/release/obj/rtc_base/third_party/base64/base64/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libtask_queue.a webrtc-checkout/src/out/release/obj/api/task_queue/task_queue/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libfile_wrapper.a webrtc-checkout/src/out/release/obj/rtc_base/system/file_wrapper/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libyield_policy.a webrtc-checkout/src/out/release/obj/rtc_base/synchronization/yield_policy/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libplatform_thread.a webrtc-checkout/src/out/release/obj/rtc_base/platform_thread/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libbad_optional_access.a webrtc-checkout/src/out/release/obj/third_party/abseil-cpp/absl/types/bad_optional_access/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_event_log.a webrtc-checkout/src/out/release/obj/api/rtc_event_log/rtc_event_log/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtp_parameters.a webrtc-checkout/src/out/release/obj/api/rtp_parameters/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libmedia_transport_interface.a webrtc-checkout/src/out/release/obj/api/transport/media/media_transport_interface/*.o

ar -rcs /home/prajwala/praj_code/ipopTincan/Tincan/external/3rd-Party-Libs/release/librtp_receiver.a webrtc-checkout/src/out/release/obj/call/rtp_receiver/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtp_rtcp_format.a webrtc-checkout/src/out/release/obj/modules/rtp_rtcp/rtp_rtcp_format/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libmedia_transport_interface.a webrtc-checkout/src/out/release/obj/api/transport/media/media_transport_interface/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/librtc_media_base.a webrtc-checkout/src/out/release/obj/media/rtc_media_base/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/release/libsrtp.a webrtc-checkout/src/out/release/obj/third_party/libsrtp/libsrtp/*.o


cd ../../../../..
#getting the required include files and folders from webrtc-checkout
# folders required: absl,api,base,call,common_video,logging,media,modules,p2p,pc,system_wrappers,rtc_base,build,common_types.h, jni.h, logging_buildflags.h
mkdir -p  ipop-project/Tincan/external/include/webrtc/build
cp -r webrtc-checkout/src/third_party/abseil-cpp/absl ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/api ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/base ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/call ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/common_video ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/logging ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/media ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/modules ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/p2p ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/pc ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/system_wrappers ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/rtc_base ipop-project/Tincan/external/include/webrtc
cp -r webrtc-checkout/src/third_party/jsoncpp/source/include/json ipop-project/Tincan/external/include
cp webrtc-checkout/src/common_types.h ipop-project/Tincan/external/include/webrtc
cp webrtc-checkout/src/third_party/ffmpeg/libavcodec/jni.h ipop-project/Tincan/external/include/webrtc
cp webrtc-checkout/src/out/release/gen/base/logging_buildflags.h ipop-project/Tincan/external/include/webrtc/base
cp webrtc-checkout/src/build/build_config.h ipop-project/Tincan/external/include/webrtc/build
cp webrtc-checkout/src/build/buildflag.h ipop-project/Tincan/external/include/webrtc/build
