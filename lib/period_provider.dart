import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/database_helper.dart';

class PeriodProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Period> _periods = [];

  List<Period> get periods => _periods;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 添加一个计算属性来获取最近的一个周期，根据update_at字段排序
  Period? get lastPeriod {
    if (_periods.isNotEmpty) {
      return _periods.reduce(
        (a, b) => a.updatedAt.isAfter(b.updatedAt) ? a : b,
      );
    } else {
      return null;
    }
  }

  Future<void> loadPeriods() async {
    _isLoading = true;
    notifyListeners();

    _periods = await _dbHelper.getPeriods();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _insertPeriod(Period period) async {
    await _dbHelper.insertPeriod(period);
    await loadPeriods();
  }

  Future<int> getIdFromDatabase() async {
    final periods = await _dbHelper.getPeriods();
    if (periods.isNotEmpty) {
      final lastPeriod = periods.last; // 获取最后一个周期
      final lastId = lastPeriod.id; // 获取最后一个周期的ID
      return lastId + 1; // 返回ID加1的结果
    } else {
      return 0;
    }
  }

  Future<void> addPeriod(DateTime? start, DateTime? end) async {
    final period = Period.initialize(start: start!, end: end);
    await _insertPeriod(period);
  }

  Future<void> editPeriod(Period period) async {
    await _updatePeriod(period);
  }

  Future<void> _updatePeriod(Period period) async {
    await _dbHelper.updatePeriod(period);
    await loadPeriods();
  }

  Future<void> deletePeriod(int id) async {
    await _dbHelper.deletePeriod(id);
    await loadPeriods();
  }
}
