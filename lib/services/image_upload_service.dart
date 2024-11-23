import 'dart:io';

import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/models/upload_receive.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';

///图片上传管理
class ImageUploadService extends AppBaseController {
  static ImageUploadService? _instance;

  factory ImageUploadService() => _instance ??= ImageUploadService._();

  ImageUploadService._();

  Function(bool isSuccess, {ImageModel? model})? onUploadSuc;

  ///选择相册
  selectPicker(Function(bool isSuccess, {ImageModel? model}) onUploadSuc) {
    this.onUploadSuc = onUploadSuc;
    List<String> data = ["拍照", "从相册中选择"];
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.dark,
        actions: data,
        onClick: (index) async {
          if (index == 1) {
            _selectImg();
          } else if (index == 2) {
            PermissionStatus status = await Permission.camera.request();
            if (status != PermissionStatus.granted) {
              ToastUtils.show("请打相机权限");
            } else {
              _openCamera();
            }
          }
        });
  }

  _selectImg() async {
    List<Media> listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showGif: true,
        selectCount: 1,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: false, height: 1, width: 1),
        compressSize: 500,
        uiConfig: UIConfig(
          uiThemeColor: AppTheme.colorNavBar,
        ));
    if (listImagePaths.isNotEmpty) {
      for (var media in listImagePaths) {
        File file = File(media.path!);
        await _onUpload(file);
      }
    }
  }

  _openCamera() {
    ImagePickers.openCamera().then((Media? media) {
      if (media != null) {
        File file = File(media.path!);
        _onUpload(file);
      }
    });
  }

  _onUpload(File file) async {
    try {
      showCommit();
      var value = await uploadFile(AppApi.uploadUrl,
          params: {"file": await dio.MultipartFile.fromFile(file.path)});
      UploadReceive uploadReceive = UploadReceive.fromJson(value.data);
      if (onUploadSuc != null) {
        onUploadSuc!(true,
            model: ImageModel(
                imageUrl: uploadReceive.url, imageId: uploadReceive.id));
        file.delete();
        onUploadSuc = null;
      }
    } catch (e) {
      file.delete();
      ToastUtils.show("上传失败");
      if (onUploadSuc != null) {
        onUploadSuc!(false);
        onUploadSuc = null;
      }
    }
  }
}
