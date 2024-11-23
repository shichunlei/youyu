import 'dart:convert';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/sp_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/modules/submod/report/report_logic.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:get/get.dart';

///发布监听
mixin DynamicPublishListener {
  onPublishSuccess();
}

///点赞评论监听
mixin DynamicUserLikeOrCommentListener {
  onUserLikeOrCommentChanged(DiscoverItem? item);
}

///删除评论监听
mixin DynamicDeleteListener {
  onDynamicDelete(DiscoverItem? item);
}

///动态相关管理
class DynamicController extends AppBaseController {
  static DynamicController get to => Get.find<DynamicController>();

  ///发布监听
  final List<DynamicPublishListener> _publishObservers = [];

  //监听
  addPublishObserver(DynamicPublishListener listener) {
    _publishObservers.add(listener);
  }

  removePublishObserver(DynamicPublishListener listener) {
    _publishObservers.remove(listener);
  }

  ///点赞&评论相关
  final List<DynamicUserLikeOrCommentListener> _likeOrCommentObservers = [];

  //监听
  addUserLikeOrCommentObserver(DynamicUserLikeOrCommentListener listener) {
    _likeOrCommentObservers.add(listener);
  }

  removeUserLikeOrCommentObserver(DynamicUserLikeOrCommentListener listener) {
    _likeOrCommentObservers.remove(listener);
  }

  onClickLike(DiscoverItem? model, {Function? onError}) {
    if (model != null) {
      request(AppApi.dynamicLikeUrl, params: {'dynamic_id': model.id})
          .then((value) {})
          .catchError((e) {
        if (onError != null) {
          onError();
        }
      });
    }
  }

  //点赞改变
  onLikeChanged(DiscoverItem? model) {
    var like = model?.like ?? 0;
    if (model?.isLike == 1) {
      model?.isLike = 0;
      if (like > 0) {
        model?.like = like - 1;
      }
    } else {
      model?.isLike = 1;
      model?.like = like + 1;
    }
    //通知
    for (DynamicUserLikeOrCommentListener listener in _likeOrCommentObservers) {
      listener.onUserLikeOrCommentChanged(model);
    }
  }

  ///删除相关

  final List<DynamicDeleteListener> _delObservers = [];

  //删除
  onClickDel(DiscoverItem? model) {
    AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
        msg: "确定删除此动态", msgFontSize: 14.sp, onCommit: () async {
      showCommit();
      try {
        await request(AppApi.dynamicDelUrl, params: {"id": model?.id});
        for (DynamicDeleteListener listener in _delObservers) {
          listener.onDynamicDelete(model);
        }
      } catch (e) {
        hiddenCommit();
        ToastUtils.show("删除失败");
      }
    });
  }

  //监听
  addDeleteObserver(DynamicDeleteListener listener) {
    _delObservers.add(listener);
  }

  removeDeleteObserver(DynamicDeleteListener listener) {
    _delObservers.remove(listener);
  }

  ///保存编辑相关
  //保存发布编辑
  onSaveEdit(DynamicEditData editData) {
    String json = jsonEncode(DynamicEditData.toJson(editData));
    StorageUtils.setValue('dynamic_edit', json);
  }

  onGetEditData() async {
    String json = await StorageUtils.getValue('dynamic_edit', '');
    if (json.isNotEmpty) {
      DynamicEditData data = DynamicEditData.fromJson(jsonDecode(json));
      return data;
    }
    return null;
  }

  //移除编辑
  onRemoveEdit() {
    StorageUtils.remove('dynamic_edit');
  }

  ///事件
  //进入用户主页
  onClickUser(DiscoverItem? model) {
    UserController.to
        .pushToUserDetail(model?.userInfo?.id ?? 0, UserDetailRef.other);
  }

  //进入直播间
  onClickLive(DiscoverItem? model) {
    LiveService().pushToLive(model?.userInfo?.thisRoomInfo?.id,
        model?.userInfo?.thisRoomInfo?.groupId);
  }

  //点击图片
  onClickImage(DiscoverItem? model, int imageIndex, String itemTag) {
    Get.toNamed(AppRouter().otherPages.bigImageRoute.name, arguments: {
      "index": imageIndex,
      "list": model?.images,
      "itemTag": itemTag
    });
  }

  //进入详情
  onClickDetail(DiscoverItem? model, {int? dId}) {
    Get.toNamed(AppRouter().discoverPages.discoverDetailRoute.name,
        preventDuplicates: false,
        arguments: {"dynamicId": dId, "model": model});
  }

  //评论
  onClickComment(DiscoverItem? model) {
    Get.toNamed(AppRouter().discoverPages.discoverDetailRoute.name,
        preventDuplicates: false, arguments: {"model": model});
  }

  //点击更多
  onClickMore(DiscoverItem? model) {
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.dark,
        actions: ["举报", model?.userInfo?.isBlock == 1 ? "移出黑名单" : "拉黑"],
        onClick: (index) {
          if (index == 0) {
            Get.toNamed(AppRouter().otherPages.reportRoute.name,
                arguments: {
                  'type': ReportType.dynamic,
                  'id': model?.id.toString()
                });
          } else if (index == 1) {
            UserController.to.onBlackUserOrCancel(model?.userInfo);
          }
        });
  }

  //发布成功
  onPublishSuccess() {
    //移除编辑内容
    onRemoveEdit();
    //通知
    for (DynamicPublishListener listener in _publishObservers) {
      listener.onPublishSuccess();
    }
  }
}

class DynamicEditData {
  DynamicEditData(
      {required this.content,
      required this.imageList,
      required this.audioPath,
      required this.seconds,
      required this.isAudioFinish,
      required this.mentionUserIds,
      required this.mentionUserNames});

  //内容
  final String content;

  //图片
  final List<ImageModel> imageList;

  //语音相关
  final String audioPath;

  //时间(秒)
  final int seconds;

  final bool isAudioFinish;

  //用户ids
  final List<String> mentionUserIds;
  final List<String> mentionUserNames;

  static DynamicEditData fromJson(Map<String, dynamic> json) => DynamicEditData(
      content: json['content'] as String,
      imageList: (json['imageList'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          const [],
      audioPath: json['audioPath'] as String,
      seconds: json['seconds'] as int,
      mentionUserIds: (json['mentionUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mentionUserNames: (json['mentionUserNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAudioFinish: json['isAudioFinish'] as bool);

  static Map<String, dynamic> toJson(DynamicEditData instance) =>
      <String, dynamic>{
        'content': instance.content,
        'imageList': instance.imageList.map((e) => e.toJson()).toList(),
        'audioPath': instance.audioPath,
        'seconds': instance.seconds,
        'mentionUserIds': instance.mentionUserIds,
        'isAudioFinish': instance.isAudioFinish,
        'mentionUserNames': instance.mentionUserNames
      };
}
