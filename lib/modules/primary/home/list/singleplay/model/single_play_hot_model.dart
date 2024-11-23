import 'package:youyu/models/room_list_item.dart';

class SinglePlayHotModel {
  SinglePlayHotModel(this.title, this.image, {required this.list});

  final String title;
  final String image;
  final List<RoomListItem> list;

  List<RoomListItem> fiveList = [];
  List<RoomListItem> extraList = [];

  dealWithData() {
    if (list.length > 5) {
      int i = 0;
      for (var value in list) {
        if (i < 5) {
          fiveList.add(value);
        } else {
          extraList.add(value);
        }
        i++;
      }
    } else {
      fiveList.addAll(list);
    }

    return this;
  }
}
