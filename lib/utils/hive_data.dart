import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box _box;

  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    _box = await Hive.openBox('myBox'); // Use a meaningful name for your box
  }

  // Save a string object
  Future<void> saveObject(String key, String value) async {
    await _box.put(key, value);
  }

  // Save an integer object
  Future<void> saveIntObject(String key, int value) async {
    await _box.put(key, value);
  }

  // Get a saved object
  String? getSavedObject(String key) {
    return _box.get(key);
  }

  // Clear a value
  Future<void> clearSavedObject(String key) async {
    await _box.delete(key);
  }


}
