import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart';

///im 状态
mixin IMStateListener {
  onSuccess();

  onConnecting();

  onError({required int code, required String errorMsg});
}

///im 监听发送消息
mixin IMMessageSendListener {
  onSendMessageSuccess(
      {required String? sysUserId,
      required String? imGroupId,
      required V2TimMessage msg});
}

///im 消息接收监听
mixin IMMessageReceiveListener {
  onReceiveMessage(V2TimMessage msg);
}

///im 消息已读监听
mixin IMMessageC2CReadReceiptListener {
  onMessageC2CReadReceipt(List<V2TimMessageReceipt> receiptList);
}

///im 会话监听
mixin IMConversationListener {
  onConversationChanged(List<V2TimConversation> conversationList);
}

///im 群组监听
mixin IMMessageGroupListener {
  onMemberEnter(String groupID, List<V2TimGroupMemberInfo> memberList);
  onMemberLeave(String groupID, V2TimGroupMemberInfo member);
}
