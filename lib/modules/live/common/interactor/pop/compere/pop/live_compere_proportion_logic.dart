import 'package:flutter/material.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class LiveCompereProportionLogic extends AppBaseController {
  final TextEditingController editingController = TextEditingController();

  ///设置管理员
  onSetManager(String roomId, String userId, int proportion) async {
    showCommit();
    try {
      var value = await request(AppApi.setManageProportionUrl, params: {
        'room_id': roomId,
        'user_id': userId,
        'proportion': proportion
      });
      return value.code;
    } catch (e) {
      return -1;
    }
  }
}
