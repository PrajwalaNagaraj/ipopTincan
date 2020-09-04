#!/bin/bash

helpFunction()
{
        echo ""
        echo "Usage: $0 -b build_type"
        echo -e "\t-b build_type can be release or debug"
        exit 1 # Exit script after printing help
}

while getopts b: opt
do
        case "$opt" in
                b ) build_type="$OPTARG" ;;
                ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
        esac
done

if [ -z "$build_type" ] || [ [ "$build_type" != "debug" ] && [ "$build_type" != "release" ] ]; then
       echo "error with parameter"
       helpFunction       
fi

mkdir -p evio/external/Libs/$build_type
#getting the required .o files and .a files to 3rd party libs from webrtc-checkout
#build_type="$build_type"
ar -rcs external/$build_type/libboringssl_asm.a webrtc-checkout/src/out/$build_type/obj/third_party/boringssl/boringssl_asm/*.o

ar -rcs external/$build_type/libjsoncpp.a webrtc-checkout/src/out/$build_type/obj/third_party/jsoncpp/jsoncpp/json_reader.o webrtc-checkout/src/out/$build_type/obj/third_party/jsoncpp/jsoncpp/json_value.o webrtc-checkout/src/out/$build_type/obj/third_party/jsoncpp/jsoncpp/json_writer.o

ar -rcs external/$build_type/libboringssl.a webrtc-checkout/src/out/$build_type/obj/third_party/boringssl/boringssl/*.o
ar -rcs external/$build_type/librtc_base.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_base/*.o
ar -rcs external/$build_type/librtc_base_approved.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_base_approved/*.o
ar -rcs external/$build_type/librtc_p2p.a webrtc-checkout/src/out/$build_type/obj/p2p/rtc_p2p/*.o
ar -rcs external/$build_type/libprotobuf_lite.a webrtc-checkout/src/out/$build_type/obj/third_party/protobuf/protobuf_lite/*.o
ar -rcs external/$build_type/liblogging.a webrtc-checkout/src/out/$build_type/obj/rtc_base/logging/*.o
ar -rcs external/$build_type/librtc_event.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_event/*.o
ar -rcs external/$build_type/libstringutils.a webrtc-checkout/src/out/$build_type/obj/rtc_base/stringutils/*.o
ar -rcs external/$build_type/libtimeutils.a webrtc-checkout/src/out/$build_type/obj/rtc_base/timeutils/*.o
ar -rcs external/$build_type/libplatform_thread_types.a webrtc-checkout/src/out/$build_type/obj/rtc_base/platform_thread_types/*.o
ar -rcs external/$build_type/libcriticalsection.a webrtc-checkout/src/out/$build_type/obj/rtc_base/criticalsection/*.o
ar -rcs external/$build_type/liboptions.a webrtc-checkout/src/out/$build_type/obj/api/crypto/options/*.o
ar -rcs external/$build_type/librtc_pc_base.a webrtc-checkout/src/out/$build_type/obj/pc/rtc_pc_base/*.o
ar -rcs external/$build_type/libchecks.a webrtc-checkout/src/out/$build_type/obj/rtc_base/checks/*.o
ar -rcs external/$build_type/libsequence_checker.a webrtc-checkout/src/out/$build_type/obj/rtc_base/synchronization/sequence_checker/*.o
ar -rcs external/$build_type/libyield_policy.a webrtc-checkout/src/out/$build_type/obj/rtc_base/synchronization/yield_policy/*.o
ar -rcs external/$build_type/librtc_error.a webrtc-checkout/src/out/$build_type/obj/api/rtc_error/*.o
ar -rcs external/$build_type/libmetrics.a webrtc-checkout/src/out/$build_type/obj/system_wrappers/metrics/*.o
ar -rcs external/$build_type/libfield_trial.a webrtc-checkout/src/out/$build_type/obj/system_wrappers/field_trial/*.o
ar -rcs external/$build_type/libice_log.a webrtc-checkout/src/out/$build_type/obj/logging/ice_log/*.o
ar -rcs external/$build_type/libfield_trial_parser.a webrtc-checkout/src/out/$build_type/obj/rtc_base/experiments/field_trial_parser/*.o
ar -rcs external/$build_type/libstun.a webrtc-checkout/src/out/$build_type/obj/api/transport/stun_types/*.o
ar -rcs external/$build_type/liblibjingle_peerconnection_api.a webrtc-checkout/src/out/$build_type/obj/api/libjingle_peerconnection_api/*.o
ar -rcs external/$build_type/libstrings.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/strings/strings/*.o

ar -rcs external/$build_type/libweak_ptr.a webrtc-checkout/src/out/$build_type/obj/rtc_base/weak_ptr/*.o

ar -rcs external/$build_type/libsent_packet.a webrtc-checkout/src/out/$build_type/obj/rtc_base/network/sent_packet/*.o

ar -rcs external/$build_type/librtc_numerics.a webrtc-checkout/src/out/$build_type/obj/rtc_base/rtc_numerics/*.o

ar -rcs external/$build_type/libthrow_delegate.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/base/throw_delegate/*.o

ar -rcs external/$build_type/libbase64.a webrtc-checkout/src/out/$build_type/obj/rtc_base/third_party/base64/base64/*.o

ar -rcs external/$build_type/libtask_queue.a webrtc-checkout/src/out/$build_type/obj/api/task_queue/task_queue/*.o

ar -rcs external/$build_type/libfile_wrapper.a webrtc-checkout/src/out/$build_type/obj/rtc_base/system/file_wrapper/*.o

ar -rcs external/$build_type/libplatform_thread.a webrtc-checkout/src/out/$build_type/obj/rtc_base/platform_thread/*.o

ar -rcs external/$build_type/libbad_optional_access.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/types/bad_optional_access/*.o

ar -rcs external/$build_type/librtc_event_log.a webrtc-checkout/src/out/$build_type/obj/api/rtc_event_log/rtc_event_log/*.o

ar -rcs external/$build_type/librtp_parameters.a webrtc-checkout/src/out/$build_type/obj/api/rtp_parameters/*.o

ar -rcs external/$build_type/libmedia_transport_interface.a webrtc-checkout/src/out/$build_type/obj/api/transport/media/media_transport_interface/*.o

ar -rcs external/$build_type/librtp_receiver.a webrtc-checkout/src/out/$build_type/obj/call/rtp_receiver/*.o
ar -rcs external/$build_type/librtp_rtcp_format.a webrtc-checkout/src/out/$build_type/obj/modules/rtp_rtcp/rtp_rtcp_format/*.o

ar -rcs external/$build_type/libmedia_transport_interface.a webrtc-checkout/src/out/$build_type/obj/api/transport/media/media_transport_interface/*.o

ar -rcs external/$build_type/librtc_media_base.a webrtc-checkout/src/out/$build_type/obj/media/rtc_media_base/*.o

ar -rcs external/$build_type/libsrtp.a webrtc-checkout/src/out/$build_type/obj/third_party/libsrtp/libsrtp/*.o

ar -rcs external/$build_type/libdata_size.a webrtc-checkout/src/out/$build_type/obj/api/units/data_size/*.o

ar -rcs external/$build_type/libtime_delta.a webrtc-checkout/src/out/$build_type/obj/api/units/time_delta/*.o

ar -rcs external/$build_type/libdata_rate.a webrtc-checkout/src/out/$build_type/obj/api/units/data_rate/*.o

ar -rcs external/$build_type/libraw_logging_internal.a webrtc-checkout/src/out/$build_type/obj/third_party/abseil-cpp/absl/base/raw_logging_internal/*.o

ar -rcs external/$build_type/libvideo_rtp_headers.a webrtc-checkout/src/out/$build_type/obj/api/video/video_rtp_headers/*.o
ar -rcs external/$build_type/libc++.a webrtc-checkout/src/out/$build_type/obj/buildtools/third_party/libc++/libc++/*.o
ar -rcs external/$build_type/libc++abi.a webrtc-checkout/src/out/$build_type/obj/buildtools/third_party/libc++abi/libc++abi/*.o
