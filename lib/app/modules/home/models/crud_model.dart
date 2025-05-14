/// หน่วยข้อมูล CRUD
class CrudModel<T> {
  final T _data;

  CrudModel(this._data);

  T get data => _data;

  @override
  String toString() => _data.toString();

  /// สร้างใหม่โดยสามารถแทนที่ด้วยข้อมูล [data] ได้ ถ้าไม่ใส่ก็ใช้ข้อมูลอันเดิม
  CrudModel<T> copyWith([T? data]) => CrudModel(data ?? _data);
}

/// ผลลัพธ์ที่สำเร็จในการ CRUD
class CrudSubmissionResponse<T> {
  final bool success;
  final T data;

  CrudSubmissionResponse({required this.success, required this.data});
}

/// ถ้าพบข้อผิดพลาดในการ CRUD จะโยน [Exception] อันนี้แทน
class CrudSubmissionErrorResponseException implements Exception {
  final String message;

  CrudSubmissionErrorResponseException([this.message = '']);
}
