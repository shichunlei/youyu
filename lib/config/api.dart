class AppApi {
  ///公共
  //配置接口
  static const String configUrl = "/common/appinit";

  //版本更新
  static const String versionUrl = "/Common/Version";

  //图片上传
  static const String uploadUrl = "/common/upload";

  //验证码
  static const String smsUrl = "/common/send";

  //举报
  static const String reportCommitUrl = "/user/Report";

  //举报理由
  static const String reportListUrl = "/user/ReasonList";

  //文章详情
  static const String commonArticleUrl = "/Common/Article";

  ///登录相关
  //密码/id登录
  static const String loginUrl = "/common/login";

  //验证码登录
  static const String quickLoginUrl = "/common/mobileLogin";

  //完善用户信息后登录
  static const String perfectUserInfoUrl = "/common/perfectUserInfo";

  //检测昵称是否存在
  static const String checkNickNameUrl = "/common/checkNickname";

  //登录反馈
  static const String loginFeedBackUrl = "/common/feedback";

  //找回密码
  static const String findPwUrl = "/common/find";

  //一键登录
  static const String onKeyLoginUrl = "/common/onekeyLogin";

  ///用户相关
  //获取用户信息
  static const String userInfoUrl = "/user/getUserInfo";

  //获取他人信息
  static const String otherUserInfoUrl = "/user/otherUser";

  //批量获取用户信息
  static const String otherUserListUrl = "/user/getUsers";

  //关注用户
  static const String userFocusUrl = "/user/focusUser";

  //取消关注
  static const String userCancelFocusUrl = "/user/focusUserCancel";

  //2粉丝/3好友/1关注列表
  static const String userRelationListUrl = "/user/focusList";

  //意见反馈
  static const String userFeedBackUrl = "/user/Feedback";

  //实名认证信息
  static const String userRealInfoUrl = "/user/Realinfo";

  //提交实名认证
  static const String userCommitRealUrl = "/user/UserReal";

  //新增访客
  static const String userAddAccessUrl = "/user/addAccess";

  //访客列表
  static const String userVisitorListUrl = "/Loglist/visitor";

  //用户拉黑
  static const String userBlackUrl = "/user/UserBlock";

  //用户黑名单列表
  static const String userBlockListUrl = "/User/BlockList";

  //编辑资料
  static const String userEditUrl = "/User/edit";

  //用户照片墙列表
  static const String userPhotoListUrl = "/user/UserPhoto";

  //用户编辑照片
  static const String userPhotoSaveUrl = "/user/UserPhotoSave";

  //用户礼物墙列表
  static const String userGiftWallUrl = "/user/giftWall";

  //用户修改密码
  static const String userChangePwUrl = "/User/EditPassWord";

  //用户修改手机号
  static const String userChangePhoneUrl = "/User/EditMobile";

  //注销
  static const String userWriteOffUrl = "/user/ClosedUser";

  //我的装扮
  static const String userDressUpUrl = "/user/KnapsackDressUp";

  //设置/取消装扮
  static const String userSetDressUpUrl = "/user/DressUpGoods";

  //用户关系
  static const String userRelationUrl = "user/getRelation";

  //用户充值配置
  static const String userRechargeUrl = "user/getRecharge";

  ///首页相关
  //首页顶级type
  static const String homeIndexTypeUrl = "/index/getRoomType";

  //首页推荐列表
  static const String homeRecommendUrl = "/index/getRecommendList";

  //获取指定分类的房间列表（娱乐/交友）
  static const String homeTypeListUrl = '/index/getRoomList';

  //搜索
  static const String searchUrl = "/index/serach";

  //排行榜
  static const String rankUrl = "/index/ranking";

  //周星礼物
  static const String weekGiftUrl = "index/getWeekGiftList";

  ///动态相关
  //列表
  static const String dynamicList = "/dynamic/list";

  //发布
  static const String dynamicSendUrl = "/dynamic/release";

  //点赞/取消点赞
  static const String dynamicLikeUrl = "/dynamic/like";

  //动态发评论
  static const String dynamicSendCommentUrl = "/dynamic/sendComment";

  //获取评论列表
  static const String dynamicCommentListUrl = "/dynamic/getComment";

  //喜欢/取消 喜欢评论
  static const String dynamicLikeCommentUrl = "/dynamic/likeComment";

  //评论消息列表
  static const String dynamicCommentMsgListUrl = "/dynamic/myComentList";

  //点赞消息列表
  static const String dynamicLikeListUrl = "/dynamic/likeList";

  //提到我的消息列表
  static const String dynamicAtMsgListUrl = "/dynamic/mymentionList";

  //删除动态
  static const String dynamicDelUrl = "/Dynamic/del";

  //动态消息未读
  static const String dynamicUnReadNumUrl = "/Dynamic/UnreadNum";

  //动态详情
  static const String dynamicDetailUrl = "/Dynamic/getDynamic";

  ///im相关
  //消息主页会话接口
  static const String msgConversationUrl = "/Message/Conversation";

  //会话送礼物
  static const String msgSendGiftUrl = "/user/give";

  //公告系统/未读消息
  static const String msgSysAndNoticeUnReadUrl = "/Message/UnreadNum";

  //系统消息列表
  static const String msgSysListUrl = "/Message/System";

  //公告消息列表
  static const String msgNoticeListUrl = "/Message/Notice";

  //系统/公告清除未读
  static const String msgSynNoticeUnReadNumUrl = "/Message/CleanUnreadNum";

  ///直播间相关
  //创建直播间获取分类
  static const String liveSubClsUrl = "/room/typeList";

  //创建直播间
  static const String liveCreateUrl = "/room/create";

  //进入房间校验
  static const String liveJoinRoomUrl = "/room/joinRoom";

  //房间解锁
  static const String liveUnlockPwUrl = "/room/checkPassword";

  //直播间信息
  static const String liveInfoUrl = "/room/roomInfo";

  //获取top3用户
  static const String liveTop3Url = "/room/getRoomTop3";

  //获取在线用户列表
  static const String liveOnlineUrl = "/room/getRoonOnlineUserList";

  //连麦申请列表
  static const String liveLinkApplyListUrl = "/room/queueList";

  //连麦申请
  static const String liveLinkApplyUrl = "/room/queueApply";

  //取消连麦申请
  static const String liveLinkCancelUrl = "/room/queueClear";

  //管理连麦申请
  static const String liveLinkManageUrl = "/room/queueReject";

  //管理员列表
  static const String liveManagerListUrl = "/room/manageList";

  //直播间送礼物
  static const String liveGiftSendUrl = "/Room/Give";

  //关注/取消直播间
  static const String liveFocusUrl = "/user/FollowRoom";

  //关注直播间列表
  static const String liveFocusListUrl = "/user/FollowRoomList";

  //背包礼物
  static const String giftBackPackUrl = "/user/GiftBackpack";

  //修改房间是否可以发言
  static const String roomUpSpeakUrl = "/Room/UpSpeak";

  //修改房间信息
  static const String roomEditUrl = "/room/edit";

  //房间背景图
  static const String roomBgUrl = "/room/backgroundList";

  //设置/取消管理员
  static const String setManagerUrl = "/room/setManage";

  static const String setManageProportionUrl = "/room/setManageProportion";

  //禁言/踢出
  static const String setRoomForbidUrl = "/room/setRoomForbid";

  //禁言/踢出列表
  static const String roomForbidListUrl = "/room/roomForbidList";

  //添加打赏记录
  static const String roomRewardLogAddUrl = "/room/RewardLogAdd";

  //获取打赏记录
  static const String roomRewardLogUrl = "/room/RewardLog";

  //直播间热度
  static const String liveHeatUrl = "/room/Heat";

  //清空魅力值
  static const String liveClearRoomCharmUrl = "/room/clearRoomCharm";

  //邂逅信息
  static const String liveFriendInfoUrl = "Friends/getInfo";

  //开始邂逅
  static const String liveFriendOpenUrl = "Friends/open";

  //结束邂逅
  static const String liveFriendEndUrl = "Friends/end";

  //增加邂逅时间
  static const String liveFriendIncreaseUrl = "Friends/increase";

  //邂逅关系列表
  static const String liveFriendRelationListUrl = "Friends/relationList";

  //设置邂逅关系
  static const String liveFriendSetRelationUrl = "Friends/setRelationList";

  //获取私密小屋groupid
  static const String liveFriendGetPrivateCabinUrl = "Friends/getmPrivateCabin";

  //私密小屋礼物
  static const String livePrivateCabinGiftUrl =
      "Friends/getmPrivateCabinGiftList";

  //发送世界消息
  static const String liveSendWorldMsgUrl = "world/send";

  //获取可选择的心愿礼物
  static const String LiveBarGiftList = "bar/getGiftList";

  //获取礼物名称和礼物ID
  static const String LiveBarGiftName = "bar/getGiftName";

  //获取撩一撩礼物ID
  static const String LiveBarFlirtGiftId = "bar/getGift";

  //设置礼物
  static const String LiveBarSetGift = "bar/setWishGift";

  ///其他
  //商城列表
  static const String shopListUrl = "/Shop/GoodsList";

  //商城购买
  static const String shopBugUrl = "/Shop/BuyGoods";

  //钱包主页
  static const String walletIndexUrl = "/Wallet/Index";

  //计算兑换茶豆
  static const String calculateExchangeUrl = "/Wallet/CalculateExchange";

  //茶豆兑换
  static const String walletExchangeUrl = "/Wallet/Exchange";

  //是否有账户
  static const String walletIsAccountUrl = "/Wallet/IsAccount";

  //保存账户
  static const String walletSaveAccountUrl = "/Wallet/SaveAccount";

  //提现
  static const String walletCommitUrl = "/Wallet/Withdrawal";

  //茶豆记录
  static const String coinListUrl = "/Loglist/Coins";

  //钻石记录
  static const String diamondListUrl = "/Loglist/Diamonds";

  //充值记录
  static const String rechargeRecordeUrl = "/Loglist/Recharge";

  //提现记录
  static const String withDrawListUrl = "/Loglist/Withdrawal";

  //礼物记录
  static const String giftListUrl = "/Loglist/Gift";

  //充值
  static const String rechargeUrl = "/Recharge/SubmitRecharge";

  //支付测试
  static const String planTest = "/plan/test";

  //支付宝回调
  static const String aliCallBackUrl = "/Recharge/AlipayNotify";

  //苹果支付验证
  static const String appleUrl = "/Recharge/AppleNotifyx";

  //公会列表
  static const String conferenceUrl = "/user/UnionList";

  //判断是否可以加入公会
  static const String conferenceStateUrl = "/user/Unionstate";

  //加入公会
  static const String joinConferenceUrl = "/user/joinUnion";

  //取消申请
  static const String cancelConferenceUrl = "/user/cancelUnion";

  //退出公共
  static const String leaveConferenceUrl = "/user/exitUnion";

  ///游戏相关
  static const String wheelGameUrl = "/common/turntableInfo";
}
