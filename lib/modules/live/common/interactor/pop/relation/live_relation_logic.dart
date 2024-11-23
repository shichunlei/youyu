/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-11-03 01:15:16
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-03 21:17:28
 * @FilePath: /youyu/lib/modules/live/common/interactor/pop/relation/live_relation_logic.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/live/common/interactor/pop/relation/live_relation_model.dart';

class LiveRelationLogic extends AppBaseController {

  RelationType nullRelationType = RelationType(id: 0, name: "无关系");

  RxList<RelationType> relationList = <RelationType>[].obs;

  RxInt selectIndex = 0.obs;
  fetchList() {
    relationList.insert(0, nullRelationType);
    setIsLoading = true;
    request(AppApi.liveFriendRelationListUrl, params: {}).then((value) {
      List<dynamic> tempList = value.data;
      for (Map<String, dynamic> map in tempList) {
        RelationType entity = RelationType.fromJson(map);
        relationList.add(entity);
      }
      isNoData = true;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }
}
