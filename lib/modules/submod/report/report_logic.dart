import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/report_model.dart';
import 'package:youyu/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ReportType {
  room(type: 1), //房间
  user(type: 3), //用户
  dynamic(type: 2); //动态

  final int type;

  const ReportType({required this.type});
}

class ReportLogic extends AppBaseController {
  static int reasonUpdateId = 1;

  ///举报类型
  ReportType reportType = ReportType.room;

  ///动态/用户/或者房间id
  String id = '';

  ///理由
  List<ReportModel> reasonList = [];
  int reasonType = 0;

  ///图片相关
  RxList<ImageModel> imageList = <ImageModel>[].obs; //图片数据

  ///内容
  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    reportType = Get.arguments['type'];
    id = Get.arguments['id'].toString();
    _loadData();
  }

  _loadData() {
    setIsLoading = true;
    request(AppApi.reportListUrl).then((value) {
      reasonList.clear();
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        ReportModel entity = ReportModel.fromJson(map);
        reasonList.add(entity);
      }
      imageList.add(ImageModel(imageUrl: '', type: ImageModelType.add));
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///选择理由
  selReason(ReportModel model) {
    reasonType = model.id;
    update([ReportLogic.reasonUpdateId]);
  }

  ///选择图片
  selectImageList() {
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

  ///删除图片
  onClickDelImage(ImageModel imageModel) {
    bool isAdd = false;
    for (ImageModel model in imageList) {
      if (model.type == ImageModelType.add) {
        isAdd = true;
        break;
      }
    }
    imageList.remove(imageModel);
    if (!isAdd) {
      imageList.add(ImageModel(imageUrl: '', type: ImageModelType.add));
    }
  }

  ///提交
  submit() {
    if (reasonType == 0) {
      ToastUtils.show("请选择举报理由");
      return;
    }
    List<ImageModel> list = [];
    for (ImageModel element in imageList) {
      if (element.type == ImageModelType.normal) {
        list.add(element);
      }
    }
    if (list.isEmpty) {
      ToastUtils.show("请上传图片证据");
      return;
    }
    //获取图片id
    String imgs =
        (list.map((element) => element.imageId.toString()).toList()).join(",");
    showCommit();
    _reportCommit(imgs);
  }

  _reportCommit(imgs) {
    request(AppApi.reportCommitUrl, params: {
      'type': reportType.type,
      'describe': contentController.text.toString(),
      'report_id': id,
      'imgs': imgs,
      'reason': reasonType.toString()
    }).then((value) {
      ToastUtils.show("提交成功");
      Get.back();
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
