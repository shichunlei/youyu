import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/modules/primary/message/message/list/message_chat_list_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

class IMMsgBaseMenu extends StatelessWidget {
  const IMMsgBaseMenu(
      {super.key,
      required this.message,
      required this.isShowCopyMenu,
      required this.onHideMenu,
      required this.logic});

  final MessageChatListLogic logic;

  ///数据
  final V2TimMessage message;
  final bool isShowCopyMenu;
  final Function onHideMenu;

  static List<PopMenuModel> allItems = [
    PopMenuModel(PopMenuModelType.copy, title: '复制', icon: Icons.copy),
    PopMenuModel(PopMenuModelType.del, title: '删除', icon: Icons.delete)
  ];

  static List<PopMenuModel> delItems = [
    PopMenuModel(PopMenuModelType.del, title: '删除', icon: Icons.delete)
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: AppRow(
          mainAxisSize: MainAxisSize.min,
          height: 55.h,
          color: const Color(0xFF4C4C4C),
          children:
              (isShowCopyMenu ? IMMsgBaseMenu.allItems : IMMsgBaseMenu.delItems)
                  .map((item) => AppColumn(
                        onTap: () {
                          _onClickItem(item);
                          onHideMenu();
                        },
                        width: 55.w,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            item.icon,
                            size: 20,
                            color: Colors.white,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ))
                  .toList()),
    );
  }

  ///点击item
  _onClickItem(PopMenuModel item) {
    switch (item.type) {
      case PopMenuModelType.copy:
        {
          Clipboard.setData(ClipboardData(text: '${message.textElem?.text}'));
          ToastUtils.show('复制成功');
        }
        break;
      case PopMenuModelType.del:
        {
         logic.delMessage(message);
        }
        break;
    }
  }
}
