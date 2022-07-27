import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;
import 'dart:io' show Directory;

typedef ValidNative = Bool Function(Pointer<Int8> name, Pointer<Int8> password);
typedef Valid = bool Function(Pointer<Int8> name, Pointer<Int8> password);
bool valid(String name, String password) {
  // Open the dynamic library
  final dylib =
      DynamicLibrary.open(path.join(Directory.current.path, 'lib', 'Dll1.dll'));
  final Valid valid = dylib.lookupFunction<ValidNative, Valid>('Valid');

  bool thi = valid(
      name.toNativeUtf8().cast<Int8>(), password.toNativeUtf8().cast<Int8>());
  return thi;
}
