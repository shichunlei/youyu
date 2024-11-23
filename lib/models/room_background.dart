import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'room_background.g.dart';

@JsonSerializable()
class RoomBackGround implements BaseModel {
  final String url;
  final String suffix;

  RoomBackGround({
    required this.url,
    required this.suffix,
  });

  @override
  factory RoomBackGround.fromJson(Map<String, dynamic> json) =>
      _$RoomBackGroundFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RoomBackGroundToJson(this);
}
