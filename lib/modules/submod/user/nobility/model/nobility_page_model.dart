import 'package:youyu/models/user_nobility.dart';

class NobilityPageModel {
  NobilityPageModel({required this.nobility, required this.equityList});

  final UserNobilityModel nobility;
  final List<NobilityEquityModel> equityList;
}

class NobilityEquityModel {
  NobilityEquityModel(
      {required this.image, required this.title, required this.subTitle});

  final String image;
  final String title;
  final String subTitle;
}
