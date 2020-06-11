#!/bin/bash
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
ninja -C out/release/ boringssl protobuf_lite p2p base jsoncpp
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

cp webrtc-checkout/src/out/release/obj/third_party/boringssl/libboringssl.a ipop-project/Tincan/external/3rd-Party-Libs/release

cp webrtc-checkout/src/out/release/obj/system_wrappers/libfield_trial.a ipop-project/Tincan/external/3rd-Party-Libs/release

cp webrtc-checkout/src/out/release/obj/rtc_base/librtc_base.a ipop-project/Tincan/external/3rd-Party-Libs/release

cp webrtc-checkout/src/out/release/obj/rtc_base/librtc_base_approved.a ipop-project/Tincan/external/3rd-Party-Libs/release

cp webrtc-checkout/src/out/release/obj/p2p/librtc_p2p.a  ipop-project/Tincan/external/3rd-Party-Libs/release
cp webrtc-checkout/src/out/release/obj/third_party/protobuf/libprotobuf_lite.a  ipop-project/Tincan/external/3rd-Party-Libs/release
#converting thin archives to normal archive
cd ipop-project/Tincan/external/3rd-Party-Libs/release
for lib in `find -name '*.a'`;
	do ar -t $lib | xargs ar rvs $lib.new && mv -v $lib.new $lib;
done

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
cp webrtc-checkout/src/common_types.h ipop-project/Tincan/external/include/webrtc
cp webrtc-checkout/src/third_party/ffmpeg/libavcodec/jni.h ipop-project/Tincan/external/include/webrtc
cp webrtc-checkout/src/out/release/gen/base/logging_buildflags.h ipop-project/Tincan/external/include/webrtc/base
cp webrtc-checkout/src/build/build_config.h ipop-project/Tincan/external/include/webrtc/build
cp webrtc-checkout/src/build/buildflag.h ipop-project/Tincan/external/include/webrtc/build
