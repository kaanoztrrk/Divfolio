// ignore_for_file: avoid_print
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static final HiveManager _instance = HiveManager._internal();
  factory HiveManager() => _instance;
  HiveManager._internal();

  bool _initialized = false;

  Future<void> init({
    required List<TypeAdapter> adapters,
    required List<String> boxes,
  }) async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // adapters
    for (final a in adapters) {
      if (!Hive.isAdapterRegistered(a.typeId)) {
        Hive.registerAdapter(a);
      }
    }

    // open boxes (ALL dynamic)
    for (final name in boxes) {
      if (!Hive.isBoxOpen(name)) {
        await Hive.openBox(name);
      }
    }

    _initialized = true;
    print("✅ Hive ready (${dir.path})");
  }

  Box box(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw HiveError('Box "$name" is not open. Call init() first.');
    }
    return Hive.box(name);
  }

  // ---------- CRUD (simple) ----------
  Future<void> put(String boxName, String key, Object? value) async {
    final b = box(boxName);
    await b.put(key, value);
  }

  T? get<T>(String boxName, String key) {
    final b = box(boxName);
    final v = b.get(key);
    if (v == null) return null;
    if (v is T) return v;
    throw StateError(
      'Hive type mismatch for [$boxName][$key]: expected $T, got ${v.runtimeType}',
    );
  }

  List<T> getAll<T>(String boxName) {
    final b = box(boxName);
    return b.values.whereType<T>().toList(growable: false);
  }

  Future<void> delete(String boxName, String key) async {
    final b = box(boxName);
    await b.delete(key);
  }

  /// Filter: bütün değerler içinde predicate ile
  List<T> where<T>(String boxName, bool Function(T item) test) {
    final b = box(boxName);
    final list = b.values.whereType<T>().where(test).toList();
    return list;
  }

  /// keys üzerinden (id’ler)
  Iterable<String> keys(String boxName) =>
      box(boxName).keys.map((e) => e.toString());

  Future<void> clear(String boxName) async {
    await box(boxName).clear();
  }

  Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}
