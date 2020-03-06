import 'dart:convert';
import 'models/models.dart';

class Store {
  static Store instance = new Store();
  final StorageProvider storageProvider;
  String get _storedUserKey => "user.json";
  String get _storedTaskKey => "task.json";
  String get _storedTaskActivationKey => "activated.json";

  bool get isAuthenticated => !(_authenticatedUser?.token?.isExpired ?? true);
  User _authenticatedUser;
  User get authenticatedUser => _authenticatedUser;
  set authenticatedUser(User u) {
    _authenticatedUser = u;
    if (u != null) {
      storageProvider?.store(_storedUserKey, json.encode(u.asMap()));
    } else {
      storageProvider?.delete(_storedUserKey);
    }
  }

  Store({this.storageProvider}) {
    /*
    userController = new UserService(this)
      ..listen((u) {
        if (u?.id != authenticatedUser?.id) {
          authenticatedUser = u;
        }
      });
    */
    _loadPersistentUser();
  }

  void _loadPersistentUser() {
    if (storageProvider != null) {
      try {
        var contents = storageProvider.load(_storedUserKey);
        authenticatedUser = new User.fromMap(json.decode(contents));
          //userController.add(authenticatedUser);
      } catch (e) {
        //userController.add(null);
      };
    } else {
      //userController.add(null);
    }
  }
}

//though flutter storage requires async methods, skip it for later
abstract class StorageProvider {
  String load(String pathOrKey);
  bool store(String pathOrKey, String contents);
  bool delete(String pathOrKey);
}