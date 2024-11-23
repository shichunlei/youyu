import 'package:youyu/models/localmodel/menu_model.dart';

//vip卡片
class VipCardModel {
  VipCardModel({required this.headUrl,
    required this.userName,
    required this.subTitle,
    this.isSVip = false});

  String? headUrl;
  String? userName;
  String? subTitle;
  bool isSVip;
}

//价格
class VipPriceModel {
  VipPriceModel({required this.title,
    required this.price,
    required this.oriPrice,
    required this.tip});

  String? title;
  String? price;
  String? oriPrice;
  String? tip;
}

//更多功能
class VipMoreModel {
  VipMoreModel(
      {required this.title, required this.isSVip, required this.subTitle, required this.list});

  final bool isSVip;
  final String title;
  final String subTitle;
  final List<MenuModel> list;
}
