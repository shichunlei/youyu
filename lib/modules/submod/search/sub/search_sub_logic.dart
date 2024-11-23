import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/models/search_list.dart';
import 'package:youyu/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchSubLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  ///搜索
  TextEditingController searchController = TextEditingController();

  //搜索关键词
  String keyword = "";

  ///tab
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 0, name: "相关房间"),
    TabModel(id: 1, name: "相关用户"),
  ];

  ///数据
  final List<RoomListItem> roomList = [];
  final List<UserInfo> userList = [];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    keyword = Get.arguments;
    searchController.text = keyword;
    _requestList();
  }

  ///搜索
  search(String value) {
    if (value.isNotEmpty) {
      //判断是否和上次相同
      if (keyword != value) {
        //设置keyword
        keyword = value;
        //插入搜索值
        SearchService().insertKeyword(value);
        _requestList();
      }
    }
  }

  ///请求
  _requestList() {
    setIsLoading = true;
    request(AppApi.searchUrl, params: {'key': keyword}).then((value) {
      roomList.clear();
      userList.clear();
      SearchList list = SearchList.fromJson(value.data);
      if (list.roomList.isNotEmpty == true) {
        roomList.addAll(list.roomList);
      }
      if (list.userList.isNotEmpty == true) {
        userList.addAll(list.userList);
      }
      setSuccessType();
    }).catchError((e) {
      setIsLoading = false;
    });
  }
}
