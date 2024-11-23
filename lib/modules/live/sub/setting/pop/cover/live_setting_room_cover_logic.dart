import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/image_upload_service.dart';

class LiveSettingRoomCoverLogic extends AppBaseController {
  ImageModel? imageModel;

  onClickAdd() {
    ImageUploadService().selectPicker((isSuccess, {model}) {
      if (isSuccess) {
        imageModel = model;
        setSuccessType();
      }
    });
  }

  onUpdateCover() async {
    if (imageModel?.imageId != null) {
      showCommit();
      try {
        await request(AppApi.roomEditUrl,
            params: {'avatar': imageModel?.imageId});
        ToastUtils.show("修改成功");
        return true;
      } catch (e) {
        hiddenCommit();
      }
    }
    return false;
  }
}
