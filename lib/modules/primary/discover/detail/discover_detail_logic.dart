import 'dart:async';

import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/discover_comment_model.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/primary/discover/userlist/discover_pop_user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

///输入状态
enum DiscoverDetailInputState {
  none, //空
  text, //输入框
  emoji //emoji
}

class DiscoverDetailLogic extends AppBaseController with UserBlackListener {
  int _pageIndex = PageConfig.start;

  ///列表数据
  DiscoverItem? detailModel;

  ///评论列表
  List<DiscoverCommentModel> commentList = [];

  ///评论内容
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  ///input状态
  //当前状态
  DiscoverDetailInputState get state => _state.value;

  //记录上一个状态
  final List<DiscoverDetailInputState> _states = [
    DiscoverDetailInputState.none, //new
    DiscoverDetailInputState.none //old
  ];

  DiscoverDetailInputState get beforeState => _states.last;

  set setInputState(DiscoverDetailInputState state) {
    _states.removeLast();
    _states.insert(0, state);
    _state.value = state;
    if (state == DiscoverDetailInputState.none) {
      //键盘取消的时候情况回复相关
      pid = null;
      inputPlaceHolder.value = "请输入评论内容...";
    }
  }

  final _state = DiscoverDetailInputState.none.obs;

  ///用户ids
  RxList<String> mentionUserIds = <String>[].obs;
  RxList<String> mentionUserNames = <String>[].obs;

  ///键盘高度相关
  //距离底部高度(配合键盘)
  var inputBottomHeight = 0.0.obs;

  //emoji高度
  double emojiHeight = 280.h;

  //临时变量
  double tempBottom = 0;
  Timer? _timer;

  ///回复相关
  //二级评论id
  int? pid;
  var inputPlaceHolder = "请输入评论内容...".obs;

  @override
  void onInit() {
    super.onInit();
    //详情内容取列表的
    detailModel = Get.arguments['model'];
    UserController.to.addUserBlackObserver(this);
    //加载评论数据
    loadData();
  }

  loadData() async {
    setIsLoading = true;
    if (detailModel == null) {
      setNoneType();
      int dynamicId = Get.arguments['dynamicId'];
      var value = await request(AppApi.dynamicDetailUrl,
          params: {'dynamic_id': dynamicId});
      detailModel = DiscoverItem.fromJson(value.data);
    }
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    //获取评论内容
    request(AppApi.dynamicCommentListUrl, params: {
      'dynamic_id': detailModel?.id,
      'page': page,
      'limit': PageConfig.limit,
    }).then((value) {
      //1.改变刷新状态
      refreshController.refreshCompleted();
      //2.设置索引
      if (page == PageConfig.start) {
        commentList.clear();
      }
      _pageIndex = page + 1;
      //3.设置数据
      List<dynamic> list = value.data['rows'];
      for (Map<String, dynamic> map in list) {
        DiscoverCommentModel entity = DiscoverCommentModel.fromJson(map);
        commentList.insert(0, entity);
      }
      //4.判空
      isNoData = false;
      if (list.isEmpty && page == PageConfig.start) {
        isNoData = true;
      }
      //5.判断加载完成
      if (list.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      //6.刷新页面
      setSuccessType();
    });
  }

  //TODO: at用户 先不用
  onClickAt() async {
    onClickMaskNone();
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

  ///表情
  onClickEmoji() {
    ///根据状态判断
    switch (state) {
      case DiscoverDetailInputState.none:
        setInputState = DiscoverDetailInputState.emoji;
        inputBottomHeight.value = emojiHeight;
        closeKeyboard();
        break;
      case DiscoverDetailInputState.emoji:
        setInputState = DiscoverDetailInputState.text;
        focusNode.requestFocus();
        _delayShowKb();
        break;
      case DiscoverDetailInputState.text:
        setInputState = DiscoverDetailInputState.emoji;
        inputBottomHeight.value = emojiHeight;
        closeKeyboard();
        break;
    }
  }

  ///点击弹出键盘
  onClickShowKb() {
    setInputState = DiscoverDetailInputState.text;
    focusNode.requestFocus();
    if (beforeState == DiscoverDetailInputState.emoji) {
      _delayShowKb();
    }
  }

  ///核心
  _delayShowKb() {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: PlatformUtils.isIOS ? 650 : 500), () {
      setInputState = DiscoverDetailInputState.text;
      inputBottomHeight.value = _withoutSafeBottomHeight(tempBottom);
    });
  }

  ///键盘变化 注意只有键盘弹出bottom才会变化，否则都为0
  onKeyBoardChange(double bottom) {
    if (state == DiscoverDetailInputState.text) {
      if (beforeState == DiscoverDetailInputState.emoji) {
        tempBottom = math.max(tempBottom, bottom);
      } else {
        inputBottomHeight.value = _withoutSafeBottomHeight(bottom);
      }
    }
  }

  _withoutSafeBottomHeight(double bottom) {
    return bottom > ScreenUtils.safeBottomHeight
        ? bottom - ScreenUtils.safeBottomHeight
        : 0.0;
  }

  //点击背景消失
  onClickMaskNone() {
    setInputState = DiscoverDetailInputState.none;
    inputBottomHeight.value = 0;
    closeKeyboard();
  }

  ///发布评论 pid（二级评论id）

  //键盘提交
  onSubmitted(String text) {
    onSendComment();
  }

  //点击评论
  onClickCommentItemToReply(DiscoverCommentModel model) {
    pid = model.id;
    inputPlaceHolder.value = "回复：${model.userInfo?.nickname ?? ""}";
    onClickShowKb();
  }

  //最终提交
  onSendComment() {
    if (textController.text.isNotEmpty) {
      int? pid = this.pid;
      onClickMaskNone();
      showCommit();
      request(AppApi.dynamicSendCommentUrl, params: {
        'dynamic_id': detailModel?.id,
        'desc': textController.text,
        'pid': pid ?? 0
      }).then((value) {
        //清除信息
        textController.text = "";
        mentionUserIds.clear();
        mentionUserNames.clear();
        //通知列表
        int commentCount = detailModel?.commentCount ?? 0;
        detailModel?.commentCount = commentCount + 1;
        DynamicController.to.onLikeChanged(detailModel!);
        //刷新数据
        loadData();
      });
    } else {
      ToastUtils.show("请输入评论内容");
    }
  }

  ///评论点赞
  onCommentLikeOrCancel(DiscoverCommentModel model, Function onError) {
    request(AppApi.dynamicLikeCommentUrl,
            params: {'dynamic_id': detailModel?.id, 'comment_id': model.id})
        .then((value) {})
        .catchError((e) {
      onError();
    });
  }

  //点赞改变
  onCommentLikeChanged(DiscoverCommentModel model) {
    var like = model.likeCount ?? 0;
    if (model.isLike == 1) {
      model.isLike = 0;
      if (like > 0) {
        model.likeCount = like - 1;
      }
    } else {
      model.isLike = 1;
      model.likeCount = like + 1;
    }
  }

  ///UserBlackListener
  @override
  onUserBlackChanged(UserInfo userInfo) {
    if (userInfo.id == detailModel?.userInfo?.id) {
      detailModel?.userInfo?.isBlock = userInfo.isBlock;
    }
  }

  @override
  void loadMore() {
    super.loadMore();
    _fetchList(_pageIndex);
  }

  @override
  void reLoadData() {
    super.reLoadData();
    loadData();
  }

  @override
  void onClose() {
    UserController.to.removeUserBlackObserver(this);
    _timer?.cancel();
    super.onClose();
  }
}
