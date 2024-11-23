import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/common/interactor/pop/user/Relation_Model.dart';
import 'package:youyu/modules/submod/user/detail/sub/gift/pop/user_gift_pop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRelationLogic extends AppBaseController {
  late int userId;
  int allCount = 0;
  List<Gift> dataList = [];
  RelationModel? userRelation = RelationModel();

  @override
  void onInit() {
    super.onInit();
    setNoneType();
  }

  ///获取列表
  fetchList() {
    setIsLoading = true;
    UserController.to.fetchUserRelation(userId).then((value) {
      if (value.code == 1 && (value.data as Map).isNotEmpty) {
        userRelation = RelationModel.fromJson(value.data);
        setSuccessType();
      } else {
        userRelation = null;
      }
    }).catchError((e) {
      setErrorType(e);
    });
    //todo 主页关系页面
    // request(AppApi.userGiftWallUrl,
    //     params: {"type": "1", "sort": "1", "user_id": userId}).then((value) {
    //   allCount = value.data['all_count'];
    //   List<dynamic> list = value.data['list'];
    //   for (Map<String, dynamic> map in list) {
    //     Gift entity = Gift.fromJson(map);
    //     dataList.add(entity);
    //   }
    //   isNoData = dataList.isEmpty;
    //   setSuccessType();
    // }).catchError((e) {
    //   setErrorType(e);
    // });
  }

  ///获取列表
  // fetchList() {
  //   setIsLoading = true;
  //   request(AppApi.userGiftWallUrl,
  //       params: {"type": "1", "sort": "1", "user_id": userId}).then((value) {
  //     allCount = value.data['all_count'];
  //     List<dynamic> list = value.data['list'];
  //     for (Map<String, dynamic> map in list) {
  //       Gift entity = Gift.fromJson(map);
  //       dataList.add(entity);
  //     }
  //     isNoData = dataList.isEmpty;
  //     setSuccessType();
  //   }).catchError((e) {
  //     setErrorType(e);
  //   });
  // }

  ///点击礼物
  onClickGift(Gift itemModel) {
    Get.dialog(Center(
      child: UserGiftPop(
        itemModel: itemModel,
      ),
    ));
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
