
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class UserImageLogic extends AppBaseController {
  late int userId;
  bool isMine = false;
  List<ImageModel> dataList = [];

  @override
  void onInit() {
    super.onInit();
    setNoneType();
  }

  fetchList() async {
    setIsLoading = true;
    request(AppApi.userPhotoListUrl, params: {"user_id": userId})
        .then((value) {
      dataList.clear();
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        int imageId = 0;
        if (map['id'] is int) {
          imageId = map['id'] as int;
        } else {
          imageId = int.parse(map['id']);
        }
        dataList.add(ImageModel(imageId: imageId, imageUrl: map['url']));
      }

      if (isMine && dataList.isNotEmpty) {
        dataList.add(
          ImageModel(type: ImageModelType.add, imageUrl: ""),
        );
        dataList.add(
          ImageModel(type: ImageModelType.sub, imageUrl: ""),
        );
      }
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///进入照片管理
  onAddImage() {
    Get.toNamed(AppRouter().otherPages.userImgManagerRoute.name,
        arguments: {'userId': userId})?.then((value) {
      if (value is bool && value == true) {
        fetchList();
      }
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
