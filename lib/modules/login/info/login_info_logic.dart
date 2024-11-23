import 'dart:io';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/models/upload_receive.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:youyu/widgets/app/actionsheet/app_date_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:youyu/modules/login/info/param/login_info_param.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart'; //调用相册
import 'package:permission_handler/permission_handler.dart';
import '../../../controllers/base/base_controller.dart';

class LoginInfoLogic extends AppBaseController {
  ///头像相关
  File avatarFile = File('');
  var avatar = ''.obs; //头像
  int? avatarId; //头像id
  List<Media> _listImagePaths = [];

  ///昵称
  TextEditingController nameController = TextEditingController();

  ///性别
  TextEditingController sexController = TextEditingController();
  int sex = 0;

  ///生日
  TextEditingController birthDayController = TextEditingController();
  int birthDayTime = 0;

  FocusNode nameFocusNode = FocusNode();
  LoginInfoParam? param;

  @override
  void onReady() {
    super.onReady();
    param = Get.arguments;
  }

  ///选择相册
  selectHead() {
    List<String> data = ["拍照", "从相册中选择"];
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.light,
        actions: data,
        onClick: (index) {
          if (index == 1) {
            _selectImg();
          } else if (index == 2) {
            _openCamera();
          }
        });
  }

  _selectImg() async {
    _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showGif: true,
        selectCount: 1,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: false, height: 1, width: 1),
        compressSize: 500,
        uiConfig: UIConfig(
          uiThemeColor: AppTheme.colorNavBar,
        ));
    if (_listImagePaths.isNotEmpty) {
      for (var media in _listImagePaths) {
        avatarFile = File(media.path!);
        _onUpload();
      }
    }
  }

  _openCamera() async {
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ToastUtils.show("请打相机权限");
    } else {
      ImagePickers.openCamera().then((Media? media) {
        if (media != null) {
          avatarFile = File(media.path!);
          _onUpload();
        }
      });
    }
  }

  _onUpload() async {
    showCommit();
    try {
      var value = await uploadFile(AppApi.uploadUrl,
          params: {"file": await dio.MultipartFile.fromFile(avatarFile.path)});
      ToastUtils.show("上传成功");
      UploadReceive uploadReceive = UploadReceive.fromJson(value.data);
      avatar.value = uploadReceive.url;
      avatarId = uploadReceive.id;
      //清除图片
      avatarFile.delete();
    } catch (e) {
      ToastUtils.show("上传失败");
      avatarFile.delete();
    }
  }

  ///选择性别
  selectSex() {
    List<String> data = ["男", "女"];
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.light,
        actions: data,
        onClick: (index) {
          sexController.text = data[index];
          sex = index + 1;
        });
  }

  selectBirthDay() {
    AppDataPicker.showDatePiker(Get.context, onConfirm: (date) {
      birthDayController.text = "$date".substring(0, 10);
      birthDayTime = date.millisecondsSinceEpoch ~/ 1000;
    });
  }

  requestCommit() async {
    if (avatarId == null) {
      ToastUtils.show("请上传头像");
      return;
    }
    if (nameController.text.isEmpty) {
      ToastUtils.show("请输入昵称");
      return;
    }
    if (sexController.text.isEmpty) {
      ToastUtils.show("请选择性别");
      return;
    }
    if (birthDayController.text.isEmpty) {
      ToastUtils.show("请选择生日");
      return;
    }
    //1.检测昵称是否重复
    showCommit();
    try {
      await request(AppApi.checkNickNameUrl,
          isHiddenCommitLoading: false,
          params: {"nickname": nameController.text});
      //2.提交注册
      AuthController.to.registerInfoLogin(
          mobile: param?.mobile ?? "",
          code: param?.code ?? "",
          avatar: (avatarId ?? 0).toString(),
          nickname: nameController.text,
          gender: sex.toString(),
          birthTime: birthDayTime.toString());
    } catch (e) {
      hiddenCommit();
    }
  }
}
