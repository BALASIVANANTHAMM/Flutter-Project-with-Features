
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BioStorage{
  final storage = const FlutterSecureStorage(aOptions:AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  bool setString(String key, String value) {
    try {
      storage.write(key: key, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  String getString(String key) {
    if (storage.read( key: key) != null) {
      return storage.read(key:key).toString();
    } else {
      return '';
    }
  }
}