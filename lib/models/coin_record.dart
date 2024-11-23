import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'coin_record.g.dart';

@JsonSerializable()
class CoinRecord implements BaseModel {
  final int id;

  @JsonKey(name: 'user_id')
  final int? userId;

  //1 => '后台充值', 2 => '送礼转出', 3 => '兑换转入', 4 => '抽奖', 5 => '转赠', 6=>'渠道充值', 7=>'购买商品',
  final int? type;

  final String? number;

  final String? desc;

  @JsonKey(name: 'create_time')
  final int? createTime;

  @JsonKey(name: 'data_id')
  final int? dataId;

  CoinRecord({
    required this.id,
    this.userId,
    this.type,
    this.createTime,
    this.number,
    this.desc,
    this.dataId,
  });

  @override
  factory CoinRecord.fromJson(Map<String, dynamic> json) =>
      _$CoinRecordFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$CoinRecordToJson(this);
}
