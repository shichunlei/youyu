import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/primary/home/list/singleplay/widget/single_play_item.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/material.dart';

class SinglePlayFiveWidget extends StatelessWidget {
  const SinglePlayFiveWidget({super.key, required this.roomList});

  final List<RoomListItem> roomList;

  @override
  Widget build(BuildContext context) {
    double widgetWidth = (ScreenUtils.screenWidth - ((13 + 14) * 2).w);
    double bigItemW = widgetWidth / 2 - 7/2.w;
    RoomListItem firstRoom = roomList[0];
    return SizedBox(
      width: widgetWidth,
      height: bigItemW,
      child: Row(
        children: [
          //第一个大item
          InkWell(
            onTap: () {
              LiveService().pushToLive(firstRoom.id, firstRoom.groupId);
            },
            child: SizedBox(
              width: bigItemW,
              height: bigItemW,
              child: SinglePlayItem(
                model: firstRoom,
                lockSize: 64.w,
                isShowTag: true,
              ),
            ),
          ),
          SizedBox(
            width: 7.w,
          ),
          //列表
          Expanded(
              child: SizedBox(
            width: bigItemW,
            height: bigItemW,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //水平子Widget之间间距
                  crossAxisSpacing: 7.w,
                  //垂直子Widget之间间距
                  mainAxisSpacing: 7.w,
                  //一行的Widget数量
                  crossAxisCount: 2,
                  //子Widget宽高比例
                  childAspectRatio: 75 / 75,
                ),
                itemCount: roomList.length - 1,
                itemBuilder: (BuildContext context, int index) {
                  RoomListItem itemModel = roomList[index + 1];
                  return InkWell(
                    onTap: () {
                      LiveService().pushToLive(itemModel.id, itemModel.groupId);
                    },
                    child: SinglePlayItem(
                      model: itemModel,
                      lockSize: 34.w,
                      isShowTag: false,
                    ),
                  );
                }),
          ))
        ],
      ),
    );
  }
}
