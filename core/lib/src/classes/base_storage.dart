import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class BaseStorage {
  static late final GetStorage _storage; // Shared storage instance

  /// Initializes GetStorage with a single container name. Call this once in the main function.
  static Future<void> initialize([String container = 'BaseStorage']) async {
    await GetStorage.init(
        container); // Initializes only once with the specified container
    _storage =
        GetStorage(container); // Assigns the container instance to _storage
    debugPrint('[BaseStorage] Initialized with container "$container"');
  }

  /// Writes a value to storage with a specified key.
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Reads a value from storage with a specified key.
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Removes a value from storage with a specified key.
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// Clears all data in the storage container.
  Future<void> erase() async {
    await _storage.erase();
  }

  /// Checks if there is data for a given key.
  bool hasData(String key) {
    return _storage.hasData(key);
  }

  /// Saves any pending changes to storage (if needed).
  Future<void> save() async {
    // In GetStorage, save operations are auto-handled,
    // but if you need a custom save mechanism, add it here.
  }
}
