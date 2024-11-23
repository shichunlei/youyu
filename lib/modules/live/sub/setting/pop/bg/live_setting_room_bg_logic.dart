import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class LiveSettingRoomBgLogic extends AppBaseController {
  ///当前url
  String? curUrl;

  int? roomId;

  ///图片列表
  List<ImageModel> imageList = [];

  ///当前选中的
  ImageModel? selModel;

  fetchList() {
    setIsLoading = true;
    request(AppApi.roomBgUrl,params: {
      'room_id': roomId
    }).then((value) {
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        ImageModel entity = ImageModel(
            imageUrl: map['url'], imageId: map['id'], ext: map['suffix']);
        imageList.add(entity);
        if (curUrl == entity.imageUrl) {
          selModel = entity;
        }
        setSuccessType();
      }
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///更新背景
  onUpdateBg() async {
    showCommit();
    try {
      await request(AppApi.roomEditUrl,
          params: {'background': selModel?.imageId});
      ToastUtils.show("修改成功");
      return true;
    } catch (e) {
      hiddenCommit();
    }
    return false;
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
