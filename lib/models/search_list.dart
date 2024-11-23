import 'package:youyu/models/room_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';
import 'my_getuserinfo.dart';

part 'search_list.g.dart';

@JsonSerializable()
class SearchList implements BaseModel {

  @JsonKey(name: 'room_list')
  final List<RoomListItem> roomList;

  @JsonKey(name: 'user_list')
  final List<UserInfo> userList;


  SearchList({
    required this.roomList,
    required this.userList,
  });

  @override
  factory SearchList.fromJson(Map<String, dynamic> json) =>
      _$SearchListFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$SearchListToJson(this);
}
