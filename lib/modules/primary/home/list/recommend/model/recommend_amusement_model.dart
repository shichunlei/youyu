
import 'package:youyu/models/room_list_item.dart';

///推荐房间
class RecommendHomeModel {

  RecommendHomeModel(this.title, this.image, {required this.list});

  final String title;
  final String image;
  final List<RoomListItem> list;

}