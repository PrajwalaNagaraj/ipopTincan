#!/bin/bash
#Ensure git works in the setup
#steps to install webrtc M84[4147] version for $build_type build
if [ ! -O "$0" ]; then 
	echo 'Must be an owner to execute'
	exit 1;
fi
helpFunction()
{
   echo ""
   echo "Usage: $0 -b build_type -t target_os"
   echo -e "\t-b build_type can be $build_type or debug"
   echo -e "\t-t target_os can be ubuntu or raspberry-pi"
   exit 1 # Exit script after printing help
}

while getopts b:t: opt
do
   case "$opt" in
      b ) build_type="$OPTARG" ;;
      t ) target_os="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$build_type" ] || [ -z "$target_os" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi
if [ "$build_type" != "debug" ] && [ "$build_type" != "$build_type" ]; then
       echo "Wrong build_type spelling"
       helpFunction
elif [ "$target_os" != "ubuntu" ] && [ "$target_os" != "raspberry-pi" ]; then
	echo "Wrong OS type spelling"
	helpFunction
fi
#for gn cmd
debug_flag=false
if [ "$build_type" == "debug" ]; then
	$debug_flag = true;
	echo "here"
fi

sudo apt install clang
sudo apt-get install libc++-dev
mkdir -p ~/workspace/webrtc-checkout && cd ~/workspace/webrtc-checkout
#install Toolchain according to OS
if [ "$target_os" == "ubuntu" ]; then
	sudo apt-get update && sudo apt-get -y install git python
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
	export PATH=`pwd`/depot_tools:"$PATH"
else
	sudo apt update && sudo apt install -y debootstrap qemu-user-static git python3-dev
	sudo git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /opt/depot_tools
	echo "export PATH=/opt/depot_tools:\$PATH" | sudo tee /etc/profile.d/depot_tools.sh
	sudo git clone https://github.com/raspberrypi/tools.git /opt/rpi_tools
	echo "export PATH=/opt/rpi_tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:\$PATH" | sudo tee /etc/profile.d/rpi_tools.sh
	sudo chown -R `whoami`:`whoami` /opt/depot_tools /opt/rpi_tools
	source /etc/profile
	sudo debootstrap --arch armhf --foreign --include=g++,libasound2-dev,libpulse-dev,libudev-dev,libexpat1-dev,libnss3-dev,libgtk2.0-dev jessie rootfs
	sudo cp /usr/bin/qemu-arm-static rootfs/usr/bin/
	sudo chroot rootfs /debootstrap/debootstrap --second-stage
	find rootfs/usr/lib/arm-linux-gnueabihf -lname '/*' -printf '%p %l\n' | while read link target; do sudo ln -snfv "../../..${target}" "${link}"; done
	find rootfs/usr/lib/arm-linux-gnueabihf/pkgconfig -printf "%f\n" | while read target; do sudo ln -snfv "../../lib/arm-linux-gnueabihf/pkgconfig/${target}" rootfs/usr/share/pkgconfig/${target}; done
fi

#build webrtc
errormsg=$( fetch --nohooks webrtc 2>&1)
if [[ "$errormsg" == *"error"* ]]; then
	echo $errormsg
	exit 1;
fi
cd src
git checkout branch-heads/4147
errormsg=$( gclient sync 2>&1)
if [[ "$errormsg" == *"error"* ]]; then
        echo $errormsg
        exit 1;
fi

if [ "$target_os" == "ubuntu" ]; then
	sudo apt-get install gtk2.0
else
	./build/install-build-deps.sh
	./build/linux/sysroot_scripts/install-sysroot.py --arch=arm
fi

if [ "$target_os" == "ubuntu" ]; then
	gn gen out/$build_type "--args=enable_iterator_debugging=false is_component_build=false is_debug=$debug_flag"
else
	gn gen out/$build_type "--args='target_os=\"linux\" target_cpu=\"arm\" is_debug=$debug_flag enable_iterator_debugging=false is_component_build=false is_debug=true rtc_build_wolfssl=true rtc_build_ssl=false rtc_ssl_root=\"/usr/local/include\"\'"
fi

errormsg=$( ninja -C out/$build_type/ boringssl boringssl_asm protobuf_lite rtc_p2p rtc_base_approved rtc_base jsoncpp rtc_event logging pc api rtc_pc_base call 2>&1)
if [[ "$errormsg" == *"error"* ]] || [[ "$errormsg" == *"fatal"* ]]; then
        echo $errormsg
        exit 1;
fi

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
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libboringssl_asm.a webrtc-checkout/src/out/$build_type/obj/third_party/boringssl/boringssl_asm/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libjsoncpp.a webrtc-checkout/src/out/$build_type/obj/third_party/jsoncpp/jsoncpp/json_reader.o webrtc-checkout/src/out/$build_type/obj/third_party/jsoncpp/jsoncpp/json_value.o webrtc-checkout/src/out/$build_type/obj/third_party/jsoncpp/jsoncpp/json_writer.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libboringssl.a webrtc-checkout/src/out/$build_type/obj/third_party/boringssl/boringssl/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_base.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_base/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_base_approved.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_base_approved/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_p2p.a webrtc-checkout/src/out/$build_type/obj/p2p/rtc_p2p/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libprotobuf_lite.a webrtc-checkout/src/out/$build_type/obj/third_party/protobuf/protobuf_lite/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/liblogging.a webrtc-checkout/src/out/$build_type/obj/rtc_base/logging/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_event.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_event/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libstringutils.a webrtc-checkout/src/out/$build_type/obj/rtc_base/stringutils/*.o
ar -rcs ipop-project//Tincan/external/3rd-Party-Libs/$build_type/libtimeutils.a webrtc-checkout/src/out/$build_type/obj/rtc_base/timeutils/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libplatform_thread_types.a webrtc-checkout/src/out/$build_type/obj/rtc_base/platform_thread_types/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libcriticalsection.a webrtc-checkout/src/out/$build_type/obj/rtc_base/criticalsection/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/liboptions.a webrtc-checkout/src/out/$build_type/obj/api/crypto/options/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libsequence_checker.a webrtc-checkout/src/out/$build_type/obj/rtc_base/sequence_checker/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_pc_base.a webrtc-checkout/src/out/$build_type/obj/pc/rtc_pc_base/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libchecks.a webrtc-checkout/src/out/$build_type/obj/rtc_base/checks/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libmetrics.a webrtc-checkout/src/out/$build_type/obj/system_wrappers/metrics/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libfield_trial.a webrtc-checkout/src/out/$build_type/obj/system_wrappers/field_trial/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libice_log.a webrtc-checkout/src/out/$build_type/obj/logging/ice_log/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libfield_trial_parser.a webrtc-checkout/src/out/$build_type/obj/rtc_base/experiments/field_trial_parser/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libstun.a webrtc-checkout/src/out/$build_type/obj/api/transport/stun_types/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/liblibjingle_peerconnection_api.a webrtc-checkout/src/out/$build_type/obj/api/libjingle_peerconnection_api/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libstrings.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/strings/strings/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libweak_ptr.a webrtc-checkout/src/out/$build_type/obj/rtc_base/weak_ptr/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libsent_packet.a webrtc-checkout/src/out/$build_type/obj/rtc_base/network/sent_packet/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_numerics.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_numerics/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libthrow_delegate.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/base/throw_delegate/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libbase64.a webrtc-checkout/src/out/$build_type/obj/rtc_base/third_party/base64/base64/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libtask_queue.a webrtc-checkout/src/out/$build_type/obj/api/task_queue/task_queue/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libfile_wrapper.a webrtc-checkout/src/out/$build_type/obj/rtc_base/system/file_wrapper/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libplatform_thread.a webrtc-checkout/src/out/$build_type/obj/rtc_base/platform_thread/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libbad_optional_access.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/types/bad_optional_access/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_event_log.a webrtc-checkout/src/out/$build_type/obj/api/rtc_event_log/rtc_event_log/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtp_parameters.a webrtc-checkout/src/out/$build_type/obj/api/rtp_parameters/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libmedia_transport_interface.a webrtc-checkout/src/out/$build_type/obj/api/transport/media/media_transport_interface/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtp_receiver.a webrtc-checkout/src/out/$build_type/obj/call/rtp_receiver/*.o
ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtp_rtcp_format.a webrtc-checkout/src/out/$build_type/obj/modules/rtp_rtcp/rtp_rtcp_format/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libmedia_transport_interface.a webrtc-checkout/src/out/$build_type/obj/api/transport/media/media_transport_interface/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/librtc_media_base.a webrtc-checkout/src/out/$build_type/obj/media/rtc_media_base/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libsrtp.a webrtc-checkout/src/out/$build_type/obj/third_party/libsrtp/libsrtp/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libdata_size.a webrtc-checkout/src/out/$build_type/obj/api/units/data_size/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libtime_delta.a webrtc-checkout/src/out/$build_type/obj/api/units/time_delta/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libdata_rate.a webrtc-checkout/src/out/$build_type/obj/api/units/data_rate/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libraw_logging_internal.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/base/raw_logging_internal/*.o

ar -rcs ipop-project/Tincan/external/3rd-Party-Libs/$build_type/libvideo_rtp_headers.a webrtc-checkout/src/out/$build_type/obj/api/video/video_rtp_headers/*.o
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
cp webrtc-checkout/src/out/$build_type/gen/base/logging_buildflags.h ipop-project/Tincan/external/include/webrtc/base
cp webrtc-checkout/src/build/build_config.h ipop-project/Tincan/external/include/webrtc/build
cp webrtc-checkout/src/build/buildflag.h ipop-project/Tincan/external/include/webrtc/build
