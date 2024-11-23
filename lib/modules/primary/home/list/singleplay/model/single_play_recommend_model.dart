
import 'package:youyu/models/room_list_item.dart';

class SinglePlayRecommendModel {
  SinglePlayRecommendModel(this.title, this.image, {required this.list});

  final String title;
  final String image;
  final List<RoomListItem> list;
}
