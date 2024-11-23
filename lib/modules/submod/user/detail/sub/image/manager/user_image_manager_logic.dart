import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/image_upload_service.dart';
import 'package:get/get.dart';

class UserImageManagerLogic extends AppBaseController {
  double itemWidth = (ScreenUtils.screenWidth - 50.w - 12.w) / 3 - 0.5.w;

  late int userId;

  ///图片相关
  RxList<ImageModel> imageList = <ImageModel>[].obs; //图片数据

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments['userId'];
    fetchList();
  }

  fetchList() async {
    setIsLoading = true;
    request(AppApi.userPhotoListUrl, params: {"user_id": userId})
        .then((value) {
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        int imageId = 0;
        if (map['id'] is int) {
          imageId = map['id'] as int;
        } else {
          imageId = int.parse(map['id']);
        }
        imageList.add(ImageModel(imageId: imageId, imageUrl: map['url']));
      }

      setSuccessType();
    });
    imageList
        .add(ImageModel(type: ImageModelType.add, imageId: 7, imageUrl: ""));
    setSuccessType();
  }

  ///排序
  onReorder(int oldIndex, int newIndex) {
    ImageModel oldModel = imageList[oldIndex];
    ImageModel newModel = imageList[newIndex];
    if (oldModel.type != ImageModelType.add &&
        newModel.type != ImageModelType.add) {
      ImageModel model = imageList.removeAt(oldIndex);
      imageList.insert(newIndex, model);
      setSuccessType();
    }
  }

  ///开通vip
  onClickOpenVip() {}

  ///添加图片
  addImage() {
    int imageCount = 0;
    for (ImageModel model in imageList) {
      if (model.type != ImageModelType.add &&
          model.type != ImageModelType.sub) {
        imageCount++;
      }
    }
    if (imageCount >= 3) {
      ToastUtils.show("最多上传3张图片");
    } else {
      closeKeyboard();
      ImageUploadService().selectPicker((isSuccess, {model}) {
        if (isSuccess) {
          if (imageCount >= 2) {
            imageList
                .removeWhere((element) => element.type == ImageModelType.add);
            imageList.add(model!);
          } else {
            imageList.add(model!);
          }
        }
      });
    }
  }

  delImage(ImageModel model) {
    imageList.remove(model);
  }

  uploadImages() {
    showCommit();
    List<ImageModel> list = [];
    for (ImageModel model in imageList) {
      if (model.type == ImageModelType.normal) {
        list.add(model);
      }
    }
    String imgs = '';
    if (list.isNotEmpty) {
      imgs = list.map((e) => e.imageId.toString()).toList().join(",");
    }
    request(AppApi.userPhotoSaveUrl, params: {'ids': imgs})
        .then((value) {
      Get.back(result: true);
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
