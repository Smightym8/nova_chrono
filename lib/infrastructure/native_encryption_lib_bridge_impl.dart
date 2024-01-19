import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:nova_chrono/domain/repository/native_encryption_lib_bridge.dart';
import 'package:path/path.dart';

import '../main.dart';

typedef EncryptFunc = Void Function(Pointer<Utf8> plainOrCiphertext, Int32 length, Int32 key);
typedef Encrypt = void Function(Pointer<Utf8> plainOrCiphertext, int length, int key);

class NativeEncryptionLibBridgeImpl implements NativeEncryptionLibBridge {
  late String _libraryPath;

  NativeEncryptionLibBridgeImpl() {
    _libraryPath = 'libencryptionLib.so';

    if (Platform.isMacOS) {
      _libraryPath = 'libencryptionLib.dylib';
    }

    if (Platform.isWindows) {
      _libraryPath = join(
          Directory.current.path, 'lib', 'encryptionLib', 'cmake-build-release', 'libencryptionLib.dll');
    }
  }

  @override
  String encrypt(String plainOrCiphertext) {
    final encryptionLib = DynamicLibrary.open(_libraryPath);

    Encrypt encryptFunc = encryptionLib
        .lookup<NativeFunction<EncryptFunc>>('encryptAndDecrypt')
        .asFunction();

    final Pointer<Utf8> nativeString = plainOrCiphertext.toNativeUtf8();
    int length = plainOrCiphertext.length;

    encryptFunc(nativeString, length, key);

    final String encryptedString = nativeString.toDartString();

    calloc.free(nativeString);

    return encryptedString;
  }

  @override
  String decrypt(String stringToDecrypt) {
    return encrypt(stringToDecrypt);
  }
}