import 'package:youyu/models/my_getuserinfo.dart';

class LiveGroupAtMsg {
  LiveGroupAtMsg({required this.text, required this.atUsers});

  final List<UserInfo> atUsers;
  final String text;
}
