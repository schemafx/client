abstract class StorageService {
  Future<Map<String, dynamic>?> load(String key);
  Future<void> save(String key, Map<String, dynamic> data);
}
