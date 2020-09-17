llvm-ar -rcs trial/libboringssl_asm.a webrtc-checkout/src/out/debug/obj/third_party/boringssl/boringssl_asm/*.o
llvm-ar -qcs trial/libjsoncxx.a webrtc-checkout/src/out/debug/obj/third_party/jsoncpp/jsoncpp/json_reader.o webrtc-checkout/src/out/debug/obj/third_party/jsoncpp/jsoncpp/json_value.o webrtc-checkout/src/out/debug/obj/third_party/jsoncpp/jsoncpp/json_writer.o
llvm-ar -qcs trial/libboringssl.a webrtc-checkout/src/out/debug/obj/third_party/boringssl/boringssl/*.o
llvm-ar -qcs trial/libprotobuf_lite.a webrtc-checkout/src/out/debug/obj/third_party/protobuf/protobuf_lite/*.o
llvm-ar -qcs trial/libstring.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/strings/strings/*.o
llvm-ar -qcs trial/libthrow_delegate.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/base/throw_delegate/*.o
llvm-ar -qcs trial/libbad_optional_access.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/types/bad_optional_access/*.o
llvm-ar -qcs trial/libsrtp.a webrtc-checkout/src/out/debug/obj/third_party/libsrtp/libsrtp/*.o
llvm-ar -qcs trial/libraw_logging_internal.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/base/raw_logging_internal/*.o

