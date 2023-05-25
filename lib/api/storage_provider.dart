import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:riverpod/riverpod.dart';

final _storage = FirebaseStorage.instance;

/// firebase storage の path に対応する URL を返す
final storageUrlProvider = FutureProvider.family<String, String>((ref, path) async {
  return await _storage.ref(path).getDownloadURL();
});
