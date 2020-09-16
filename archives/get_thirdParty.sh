llvm-ar -rcs trial/libboringssl_asm.a webrtc-checkout/src/out/debug/obj/third_party/boringssl/boringssl_asm/*.o
llvm-ar -rcs trial/libjsoncpplite.a webrtc-checkout/src/out/debug/obj/third_party/jsoncpp/jsoncpp/json_reader.o webrtc-checkout/src/out/debug/obj/third_party/jsoncpp/jsoncpp/json_value.o webrtc-checkout/src/out/debug/obj/third_party/jsoncpp/jsoncpp/json_writer.o
llvm-ar -rcs trial/libboringssl.a webrtc-checkout/src/out/debug/obj/third_party/boringssl/boringssl/*.o
llvm-ar -rcs trial/libprotobuf_lite.a webrtc-checkout/src/out/debug/obj/third_party/protobuf/protobuf_lite/*.o
llvm-ar -rcs trial/libstring.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/strings/strings/*.o
llvm-ar -rcs trial/libthrow_delegate.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/base/throw_delegate/*.o
llvm-ar -rcs trial/libbad_optional_access.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/types/bad_optional_access/*.o
llvm-ar -rcs trial/libsrtp.a webrtc-checkout/src/out/debug/obj/third_party/libsrtp/libsrtp/*.o
llvm-ar -rcs trial/libraw_logging_internal.a webrtc-checkout/src/out/debug/obj/third_party/abseil-cpp/absl/base/raw_logging_internal/*.o

