import 'package:youyu/models/room_list_item.dart';

///热门
class RecommendHotModel {

  RecommendHotModel(this.title, this.image, {required this.list});

  final String title;
  final String image;
  final List<RoomListItem> list;

}