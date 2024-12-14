import 'dart:convert';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'base/im_msg_base_widget.dart';

///红包item
class IMMsgRedWidget extends IMMsgBaseWidget {
  const IMMsgRedWidget(
      {super.key,
      required super.message,
      required super.index,
      required super.logic});

  @override
  IMMsgRedWidgetState<IMMsgRedWidget> createState() => IMMsgRedWidgetState();
}

class IMMsgRedWidgetState<T extends IMMsgRedWidget>
    extends IMMsgBaseWidgetState<IMMsgRedWidget> {
  @override
  senderContent() {
    return AppContainer(
      radius: 12.w,
      width: 227.w,
      height: 68.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/live/accept_red_bg.png"),
            fit: BoxFit.fill),
      ),
      // strokeWidth: 1.w,
      // strokeColor: AppTheme.colorMain,
      child: _redWidget(false),
    );
  }

  @override
  receiveContent() {
    return AppContainer(
      radius: 12.w,
      width: 227.w,
      height: 68.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/live/present_red_bg.png"),
            fit: BoxFit.fill),
      ),
      child: _redWidget(true),
    );
  }

  _redWidget(bool isLeft) {
    //{data: {"amount":20,"send_user_id":781,"receive_user_id":717}, desc: change, extension: , nextElem: {}} 转 json
    final jsonString = widget.message.customElem?.data ?? '';
    MsgData msgData = MsgData();
    if (jsonString.isEmpty) return Container();
    final json = jsonDecode(jsonString);
    msgData = MsgData.fromJson(json);
    return Container(
      padding: EdgeInsets.only(left: 54.w, top: 12.w),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                msgData.amount ?? '',
                style:
                    TextStyle(fontSize: 14.w, color: const Color(0xFFFFF387)),
              ),
              SizedBox(
                width: 5.w,
              ),
              Image.asset(
                'assets/live/live_red_coin_icon.png',
                width: 12.w,
                height: 12.w,
              ),
            ],
          ),
          SizedBox(
            height: 6.w,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              isLeft
                  ? '${widget.message.nickName}向您送出了红包'
                  : '向${widget.logic.nickName}送出了红包',
              style: TextStyle(fontSize: 11.w, color: const Color(0xFFFFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}

class MsgData {
  final String? amount;
  final String? sendUserId;
  final String? receiveUserId;

  MsgData({
    this.amount,
    this.sendUserId,
    this.receiveUserId,
  });

  factory MsgData.fromJson(Map<String, dynamic> json) {
    return MsgData(
      amount: json['amount'] != null ? json['amount'].toString() : '',
      sendUserId:
          json['send_user_id'] != null ? json['send_user_id'].toString() : '',
      receiveUserId: json['receive_user_id'] != null
          ? json['receive_user_id'].toString()
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['amount'] = amount;
    data['send_user_id'] = sendUserId;
    data['receive_user_id'] = receiveUserId;
    return data;
  }
}
