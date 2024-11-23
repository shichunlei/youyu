import 'package:youyu/models/gift.dart';
//TODO:未来用到
class LiveGameMsg {
  final String name;
  final int id;
  List<Gift>? giftList;

  LiveGameMsg({required this.name, required this.id, this.giftList});

  @override
  factory LiveGameMsg.fromJson(Map<String, dynamic> json) {
    return LiveGameMsg(
      name: json['name'] as String,
      id: json['id'] as int,
    );
  }
}
