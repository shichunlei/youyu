import 'dart:io';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/models/upload_receive.dart';
import 'package:youyu/modules/primary/discover/userlist/discover_pop_user_page.dart';
import 'package:youyu/services/image_upload_service.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as dio;

///页面状态
enum DiscoverPageState { normal, emoji, audio }

///录音状态
enum DiscoverAudioRecordState {
  none, //没有
  start, //开始录音
  end, //结束录音
  finish, //完成
}

class DiscoverPublishLogic extends AppBaseController {
  ///页面状态
  final _pageState = DiscoverPageState.normal.obs;

  DiscoverPageState get pageState => _pageState.value;

  set setPageState(DiscoverPageState state) {
    _pageState.value = state;
    if (state == DiscoverPageState.normal) {
      if (audioState != DiscoverAudioRecordState.finish) {
        onDelAudio();
      }
    }
  }

  ///内容
  TextEditingController contentController = TextEditingController();

  ///图片相关
  RxList<ImageModel> imageList = <ImageModel>[].obs; //图片数据
  int maxImageCount = 9;

  ///语音相关
  File? audioFile;
  int audioId = -1;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${DateTime.now().millisecondsSinceEpoch}_sound.mp3');
  }

  //状态
  final _audioState = DiscoverAudioRecordState.none.obs;

  DiscoverAudioRecordState get audioState => _audioState.value;

  set setAudioState(DiscoverAudioRecordState state) {
    _audioState.value = state;
    if (state == DiscoverAudioRecordState.none) {
      try {
        if (!isSaveEdit) {
          deleteAudioFile();
        }
      } catch (e) {
        //...
      }
    } else if (state == DiscoverAudioRecordState.finish) {
      setPageState = DiscoverPageState.normal;
    }
  }

  //最大时长
  final maxTime = 30;

  //时间(秒)
  final seconds = 0.obs;

  //进度
  final segmentValue = 0.0.obs;

  ///用户ids
  List<String> mentionUserIds = [];
  List<String> mentionUserNames = [];

  bool isSaveEdit = false;

  @override
  void onInit() async {
    super.onInit();
    _getEditData();
  }

  ///获取编辑
  _getEditData() async {
    DynamicEditData? data = await DynamicController.to.onGetEditData();
    if (data != null) {
      //内容
      if (data.content.isNotEmpty) {
        contentController.text = data.content;
      }
      //语音
      if (data.audioPath.isNotEmpty) {
        audioFile = File(data.audioPath);
        seconds.value = data.seconds;
        if (data.isAudioFinish) {
          setAudioState = DiscoverAudioRecordState.finish;
        }
      } else {
        audioFile = await _localFile;
      }
      //图片
      if (data.imageList.isNotEmpty) {
        imageList.addAll(data.imageList);
        if (data.imageList.length < 9) {
          imageList.add(ImageModel(imageUrl: '', type: ImageModelType.add));
        }
      } else {
        imageList.add(ImageModel(imageUrl: '', type: ImageModelType.add));
      }
      //用户
      if (data.mentionUserIds.isNotEmpty) {
        mentionUserIds.addAll(data.mentionUserIds);
      }
      if (data.mentionUserNames.isNotEmpty) {
        mentionUserNames.addAll(data.mentionUserNames);
      }
      setSuccessType();
    } else {
      imageList.add(ImageModel(imageUrl: '', type: ImageModelType.add));
      audioFile = await _localFile;
    }
  }

  ///事件
  //表情
  onClickEmoji() {
    if (pageState == DiscoverPageState.emoji) {
      setPageState = DiscoverPageState.normal;
    } else {
      setPageState = DiscoverPageState.emoji;
    }
  }

  //录音
  onClickAudio() {
    if (audioState == DiscoverAudioRecordState.finish) {
      ToastUtils.show("录音已存在");
      return;
    }
    if (pageState == DiscoverPageState.audio) {
      setPageState = DiscoverPageState.normal;
    } else {
      setPageState = DiscoverPageState.audio;
    }
  }

  //删除录音
  onDelAudio() {
    VoiceService().stopAudio();
    setAudioState = DiscoverAudioRecordState.none;
    seconds.value = 0;
    segmentValue.value = 0;
  }

  //清除语音文件
  deleteAudioFile() async {
    bool isExists = await audioFile?.exists() ?? false;
    if (isExists) {
      audioFile?.delete();
    }
    audioFile = await _localFile;
  }

  //图片
  onClickImage() {
    int imageCount = 0;
    for (ImageModel model in imageList) {
      if (model.type != ImageModelType.add &&
          model.type != ImageModelType.sub) {
        imageCount++;
      }
    }
    if (imageCount >= maxImageCount) {
      ToastUtils.show("最多上传$maxImageCount张图片");
    } else {
      setPageState = DiscoverPageState.normal;
      closeKeyboard();
      ImageUploadService().selectPicker((isSuccess, {model}) {
        if (isSuccess) {
          if (imageCount >= (maxImageCount - 1)) {
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

  ///at
  onClickAt() async {
    setPageState = DiscoverPageState.normal;
    closeKeyboard();
    Map<String, List<String>>? data = await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return DiscoverPopUserPage(
            mentionUserIds: mentionUserIds,
            mentionUserNames: mentionUserNames,
          );
        });
    if (data != null && data.isNotEmpty) {
      mentionUserIds.clear();
      mentionUserNames.clear();
      List<String>? ids = data['ids'];
      if (ids != null) {
        mentionUserIds.addAll(ids);
      }
      List<String>? names = data['names'];
      if (names != null) {
        mentionUserNames.addAll(names);
      }
    }
    setSuccessType();
  }

  ///发布
  onPublish() {
    List<ImageModel> list = _getImageList();
    if (contentController.text.isEmpty && list.isEmpty && audioFile == null) {
      ToastUtils.show("请选择或者输入发布内容");
      return;
    }
    showCommit();
    if (audioFile != null && seconds.value > 0) {
      _onUploadAudio(audioFile!, list);
    } else {
      _commit(list);
    }
  }

  _onUploadAudio(File file, List<ImageModel> list) async {
    try {
      var value = await uploadFile(AppApi.uploadUrl,
          params: {"file": await dio.MultipartFile.fromFile(file.path)},
          isHiddenCommitLoading: false);
      UploadReceive uploadReceive = UploadReceive.fromJson(value.data);
      audioId = uploadReceive.id;
      file.delete();
      _commit(list);
    } catch (e) {
      hiddenCommit();
      file.delete();
      ToastUtils.show("上传失败");
    }
  }

  ///最终发布
  _commit(List<ImageModel> list) {
    request(AppApi.dynamicSendUrl, params: _getParams(list)).then((value) {
      DynamicController.to.onPublishSuccess();
      ToastUtils.show('发布成功，请等待审核');
      Get.back();
    });
  }

  ///获取图片list
  _getImageList() {
    List<ImageModel> list = [];
    for (ImageModel model in imageList) {
      if (model.type == ImageModelType.normal) {
        list.add(model);
      }
    }
    return list;
  }

  ///获取请求参数
  _getParams(List<ImageModel> list) {
    String imgs = '';
    if (list.isNotEmpty) {
      imgs = list.map((e) => e.imageId.toString()).toList().join(",");
    }
    Map<String, dynamic> params = {};
    if (contentController.text.toString().isNotEmpty) {
      params['desc'] = contentController.text.toString();
    }
    if (imgs.isNotEmpty) {
      params['imgs'] = imgs;
    }

    if (audioId > -1) {
      params['tape'] = audioId;
      params['tape_s'] = seconds.value;
    }
    if (mentionUserIds.isNotEmpty) {
      params['mention_user_ids'] = mentionUserIds.join(",");
    }
    return params;
  }

  ///返回
  onBack() {
    Map<String, dynamic> params = _getParams(_getImageList());

    if (params.keys.isNotEmpty) {
      AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
          commitBtn: "保留", cancelBtn: "不保留", msg: " 保留此次编辑", onCancel: () {
        DynamicController.to.onRemoveEdit();
        Get.back();
      }, onCommit: () {
        isSaveEdit = true;

        ///保存数据
        DynamicEditData editData = DynamicEditData(
            content: contentController.text,
            imageList: _getImageList(),
            audioPath: audioFile?.path ?? '',
            seconds: seconds.value,
            mentionUserIds: mentionUserIds,
            isAudioFinish: audioState == DiscoverAudioRecordState.finish,
            mentionUserNames: mentionUserNames);
        DynamicController.to.onSaveEdit(editData);
        Get.back();
      });
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    onDelAudio();
    super.onClose();
  }
}
