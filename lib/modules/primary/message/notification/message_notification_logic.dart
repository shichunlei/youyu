import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageNotificationLogic extends AppBaseController {
  IMMsgType msgType = IMMsgType.officialSystem;
  GlobalKey<AppTopBarState> navKey = GlobalKey<AppTopBarState>();

  List<String> dataList = [];
  final int _pageIndex = PageConfig.start;

  @override
  void onInit() {
    super.onInit();
    msgType = Get.arguments;
    loadData();
  }

  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    request(_requestUrl()).then((value) {
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        String text = map['text'];
        dataList.add(text);
      }
      isNoData = dataList.isEmpty;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  _requestUrl() {
    if (msgType == IMMsgType.officialSystem) {
      return AppApi.msgSysListUrl;
    } else {
      return AppApi.msgNoticeListUrl;
    }
  }

  @override
  void pullRefresh() {
    super.pullRefresh();
    _fetchList(PageConfig.start);
  }

  @override
  void loadMore() {
    super.loadMore();
    _fetchList(_pageIndex);
  }

  @override
  void reLoadData() {
    super.reLoadData();
    loadData();
  }
}
