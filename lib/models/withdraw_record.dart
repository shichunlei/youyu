import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'withdraw_record.g.dart';

@JsonSerializable()
class WithDrawRecord implements BaseModel {
  final int id;

  @JsonKey(name: 'user_id')
  final int? userId;

  //1 支付宝2 银行
  final String? type;

  final String? name;

  final String? account;

  final String? money;

  @JsonKey(name: 'create_time')
  final String? createTime;

  //0 未处理 1 通过 2未通过
  final int? state;

  WithDrawRecord({
    required this.id,
    this.userId,
    this.type,
    this.name,
    this.account,
    this.money,
    this.createTime,
    this.state,
  });

  @override
  factory WithDrawRecord.fromJson(Map<String, dynamic> json) =>
      _$WithDrawRecordFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$WithDrawRecordToJson(this);
}
