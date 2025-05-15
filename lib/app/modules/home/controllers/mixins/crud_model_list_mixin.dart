part of '../home_controller.dart';

mixin CrudModelListMixin on GetxController {
  /// ตัวควบคุม [ExpansionTile]
  final Map<CrudModel<String>, ExpansionTileController> _expansionTileControllers = {};

  /// ต้องมี widget key สำหรับ [ExpansionTile] ด้วย เนื่องจากเวลาลบรายการ มีบั๊คที่ทำให้รายการถถัดไปจากรายการที่ลบ
  /// จะแสดง UI เปิดแท็บอยู่ ต้องระบุ key ให้สอดคล้องกับรายการ CRUD
  final _expansionTileKeys = <CrudModel<String>, GlobalKey>{};

  /// จะต้องลบ [_expansionTileKeys] และ [_expansionTileControllers]  ประจำรายการ [model] ก่อน
  /// เพื่อป้องกันการเรียกใช้ซ้ำหลังจากที่รายการไม่ได้ใช้งานแล้ว
  void _removeTargetExpansionTiles(CrudModel<String> model) {
    _expansionTileKeys.remove(model);
    _expansionTileControllers.remove(model);
  }

  /// [ExpansionTileController] ประจำ [model]
  ExpansionTileController getExpansionTileController(CrudModel<String> model) => _expansionTileControllers[model] ??= ExpansionTileController();

  /// [Key] ประจำ [model]
  Key getExpansionTileKey(CrudModel<String> model) => _expansionTileKeys[model] ??= GlobalKey();

  /// ปิด [ExpansionTile] ที่ไม่ใช่รายการที่เปิด ณ ปัจจุบัน
  void collapseOtherExpansionTiles(ExpansionTileController excepted) {
    if (excepted.isExpanded) {
      for (final c in _expansionTileControllers.values) {
        if (c != excepted) {
          c.collapse();
        }
      }
    }
  }
}
