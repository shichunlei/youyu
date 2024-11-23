part 'banner_model.g.dart';

class BannerModel {
  BannerModel({this.id, this.img, this.sort,this.type, this.val, });

  final int? id;
  final String? img;
  final int? sort;
  final int? type;
  final String? val;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
