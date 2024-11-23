import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'upload_receive.g.dart';

@JsonSerializable()
class UploadReceive implements BaseModel {
  final int id;

  final String url;

  UploadReceive({
    required this.id,
    required this.url,
  });

  @override
  factory UploadReceive.fromJson(Map<String, dynamic> json) =>
      _$UploadReceiveFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$UploadReceiveToJson(this);
}
