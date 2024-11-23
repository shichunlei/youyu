import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'diamond_record.g.dart';

@JsonSerializable()
class DiamondRecord implements BaseModel {
  final int id;

  @JsonKey(name: 'user_id')
  final int? userId;

  //1 => '后台充值', 2 => '收礼收入', 3 => '兑换转出', 4 => '提现扣除', 5 => '提现返还', 6 => '房间分成'
  final int? type;

  final String? number;

  final String? desc;

  @JsonKey(name: 'create_time')
  final int? createTime;

  @JsonKey(name: 'data_id')
  final int? dataId;

  DiamondRecord({
    required this.id,
    this.userId,
    this.type,
    this.createTime,
    this.number,
    this.desc,
    this.dataId,
  });

  @override
  factory DiamondRecord.fromJson(Map<String, dynamic> json) =>
      _$DiamondRecordFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$DiamondRecordToJson(this);
}
