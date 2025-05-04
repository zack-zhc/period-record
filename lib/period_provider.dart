import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/database_helper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
}
