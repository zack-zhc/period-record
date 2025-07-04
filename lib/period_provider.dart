import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/database_helper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class PeriodProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Period> _periods = [];

  List<Period> get periods => _periods;

  /// 获取所有周期并按以下规则排序：
  /// 1. 没有结束日期的周期排在最前面
  /// 2. 有结束日期的周期按结束日期降序排列（越靠近现在排名越靠前）
  List<Period> get sortedPeriods {
    final unfinished = _periods.where((p) => p.end == null).toList();
    final finished = _periods.where((p) => p.end != null).toList();

    // 对已完成周期按结束日期降序排序
    finished.sort((a, b) => b.end!.compareTo(a.end!));

    return [...unfinished, ...finished];
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 添加一个计算属性来获取最近的一个周期，规则如下
  // 找到没有结束日期的周期，如果结果不止一个，按updatedAt排序，取距离现在最近的那一个
  // 如果没有找到没有结束日期的周期，对所有的周期按找结束日期排序，取距离现在最近的那一个
  Period? get lastPeriod {
    // 1. 查找所有没有结束日期的周期
    final unfinishedPeriods = _periods.where((p) => p.end == null).toList();

    if (unfinishedPeriods.isNotEmpty) {
      // 如果有多个未结束周期，按updatedAt降序排序取第一个
      unfinishedPeriods.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return unfinishedPeriods.first;
    }

    // 2. 如果没有未结束周期，查找所有有结束日期的周期
    final finishedPeriods = _periods.where((p) => p.end != null).toList();

    if (finishedPeriods.isNotEmpty) {
      // 按结束日期降序排序取第一个
      finishedPeriods.sort((a, b) => b.end!.compareTo(a.end!));
      return finishedPeriods.first;
    }

    // 3. 没有任何周期的情况
    return null;
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
    var id = await getIdFromDatabase();
    final period = Period.initialize(start: start!, end: end, id: id);
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

  // 添加加密密钥和IV (初始化向量)
  static const _encryptionKey = '32characterslongsecretkey1234567'; // 32字符密钥
  static const _encryptionIv = '16charactersiv12'; // 16字符IV

  // 获取加密器
  encrypt.Encrypter get _encrypter {
    final key = encrypt.Key.fromUtf8(_encryptionKey);
    // final iv = encrypt.IV.fromUtf8(_encryptionIv);
    return encrypt.Encrypter(encrypt.AES(key));
  }

  // 修改导出方法，添加加密
  Future<String> exportPeriodsToJson() async {
    final periodsJson = _periods.map((period) => period.toJson()).toList();
    final jsonStr = jsonEncode({
      '_is_period_data_': true,
      'periods': periodsJson,
    });
    final encrypted = _encrypter.encrypt(
      jsonStr,
      iv: encrypt.IV.fromUtf8(_encryptionIv),
    );
    return encrypted.base64;
  }

  // 修改导入方法，添加解密
  Future<void> importPeriodsFromJson(String encryptedData) async {
    try {
      final encrypter = _encrypter;
      final decrypted = encrypter.decrypt64(
        encryptedData,
        iv: encrypt.IV.fromUtf8(_encryptionIv),
      );

      final Map<String, dynamic> jsonMap = jsonDecode(decrypted);
      if (jsonMap['_is_period_data_'] == true) {
        final List<dynamic> jsonList = jsonMap['periods'];
        if (jsonList.isNotEmpty) {
          await _dbHelper.deleteAllPeriods();
          _periods = [];
          for (var json in jsonList) {
            final period = Period.fromJson(json);
            await _insertPeriod(period);
          }
        }
      } else {
        throw Exception('数据格式不正确 - 缺少标识');
      }
    } catch (e) {
      throw Exception('导入失败: ${e.toString()}');
    }
  }

  // 是否显示生理期预测
  bool _showPrediction = false;
  bool get showPrediction => _showPrediction;

  PeriodProvider() {
    loadShowPredictionPreference();
  }

  Future<void> setShowPrediction(bool value) async {
    _showPrediction = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showPrediction', value);
    notifyListeners();
  }

  Future<void> loadShowPredictionPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _showPrediction = prefs.getBool('showPrediction') ?? true;
    notifyListeners();
  }
}
