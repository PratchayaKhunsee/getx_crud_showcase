import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// ที่บันทึกข้อมูล
class LocalStorage {
  static LocalStorage? _singleton;

  /// ตัวอ่านข้อมูลจาก [SharedPreferences]
  SharedPreferences? _pref;

  /// ล็อกป้องกันการตั้งค่า [_pref] ซ้ำ
  Completer<void>? _prefLock;

  LocalStorage._instantiate() {
    _prepareInstance();
  }

  factory LocalStorage() => _singleton ??= LocalStorage._instantiate();

  /// เริ่มต้นโหลดข้อมูล
  void _prepareInstance() async {
    await _getPref();
  }

  /// ดึงตัวแปร [_pref]
  Future<SharedPreferences> _getPref() async {
    if (_prefLock?.isCompleted == false) await _prefLock?.future;

    final prevPrev = _pref;
    if (prevPrev != null) return prevPrev;

    final lock = _prefLock ??= Completer();
    final pref = _pref = await SharedPreferences.getInstance();
    lock.complete();
    return pref;
  }

  /// บันทึกข้อมูลใส่ที่ [key]
  Future<bool> set(String key, String value) async => (await _getPref()).setString(key, value);

  /// อ่านข้อมูลจากที่ [key]
  Future<String?> get(String key) async => (await _getPref()).getString(key);
}
