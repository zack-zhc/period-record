class Period {
  final int id;
  final DateTime createdAt;
  final DateTime? start;
  final DateTime? end;
  final DateTime updatedAt;

  Period({
    required this.id,
    DateTime? createdAt,
    this.start,
    this.end,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // 初始化方法
  factory Period.initialize({required DateTime start, DateTime? end, int? id}) {
    final now = DateTime.now();
    return Period(
      id: id ?? 0, // 临时ID，插入数据库后会生成新ID
      createdAt: now,
      start: start,
      end: end,
      updatedAt: now,
    );
  }

  // 从Map转换为Period对象
  factory Period.fromMap(Map<String, dynamic> map) {
    return Period(
      id: map['id'],
      start:
          map['start'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['start'])
              : null,
      end:
          map['end'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['end'])
              : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  // 将Period对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': start?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
