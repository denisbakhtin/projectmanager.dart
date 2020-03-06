import 'package:projectmanager_shared/shared.dart';
import 'dart:html';
export 'package:projectmanager_shared/shared.dart';

Store storeFactory() => Store(storageProvider: LocalStorageProvider());

class LocalStorageProvider implements StorageProvider {
  @override
  String load(String pathOrKey) => window.localStorage[pathOrKey];

  @override
  bool store(String pathOrKey, String contents) {
    window.localStorage[pathOrKey] = contents;
    return true;
  }

  @override
  bool delete(String pathOrKey) {
    window.localStorage.remove(pathOrKey);
    return true;
  }
}