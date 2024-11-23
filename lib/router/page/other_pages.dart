import 'package:youyu/widgets/gift/desc/common_gift_desc_binding.dart';
import 'package:youyu/widgets/gift/desc/common_gift_desc_view.dart';
import 'package:youyu/modules/primary/mine/children/children_binding.dart';
import 'package:youyu/modules/primary/mine/children/children_view.dart';
import 'package:youyu/modules/primary/mine/children/childrenpw/children_pw_binding.dart';
import 'package:youyu/modules/primary/mine/children/childrenpw/children_pw_view.dart';
import 'package:youyu/modules/primary/mine/feedback/feed_back_binding.dart';
import 'package:youyu/modules/primary/mine/feedback/feed_back_view.dart';
import 'package:youyu/modules/primary/mine/follow_live/follow_live_binding.dart';
import 'package:youyu/modules/primary/mine/follow_live/follow_live_view.dart';
import 'package:youyu/modules/primary/mine/friend/friend_binding.dart';
import 'package:youyu/modules/primary/mine/friend/friend_view.dart';
import 'package:youyu/modules/primary/mine/realauth/detail/real_auth_detail_binding.dart';
import 'package:youyu/modules/primary/mine/realauth/detail/real_auth_detail_view.dart';
import 'package:youyu/modules/primary/mine/realauth/index/real_auth_index_binding.dart';
import 'package:youyu/modules/primary/mine/realauth/index/real_auth_index_view.dart';
import 'package:youyu/modules/primary/mine/visit/visit_binding.dart';
import 'package:youyu/modules/primary/mine/visit/visit_view.dart';
import 'package:youyu/modules/submod/bag/bag_binding.dart';
import 'package:youyu/modules/submod/bag/bag_view.dart';
import 'package:youyu/modules/submod/big/big_image_binding.dart';
import 'package:youyu/modules/submod/big/big_image_view.dart';
import 'package:youyu/modules/submod/conference/conference_index_binding.dart';
import 'package:youyu/modules/submod/conference/conference_index_view.dart';
import 'package:youyu/modules/submod/conference/detail/conference_detail_binding.dart';
import 'package:youyu/modules/submod/conference/detail/conference_detail_view.dart';
import 'package:youyu/modules/submod/rank/rank_index_binding.dart';
import 'package:youyu/modules/submod/rank/rank_index_view.dart';
import 'package:youyu/modules/submod/report/report_binding.dart';
import 'package:youyu/modules/submod/report/report_view.dart';
import 'package:youyu/modules/submod/search/search_index_binding.dart';
import 'package:youyu/modules/submod/search/search_index_view.dart';
import 'package:youyu/modules/submod/search/sub/search_sub_binding.dart';
import 'package:youyu/modules/submod/search/sub/search_sub_view.dart';
import 'package:youyu/modules/submod/shop/shop_binding.dart';
import 'package:youyu/modules/submod/shop/shop_view.dart';
import 'package:youyu/modules/submod/user/detail/sub/edit/sub/user_edit_sub_binding.dart';
import 'package:youyu/modules/submod/user/detail/sub/edit/sub/user_edit_sub_view.dart';
import 'package:youyu/modules/submod/user/detail/sub/edit/user_edit_binding.dart';
import 'package:youyu/modules/submod/user/detail/sub/edit/user_edit_view.dart';
import 'package:youyu/modules/submod/user/detail/sub/image/manager/user_image_manager_binding.dart';
import 'package:youyu/modules/submod/user/detail/sub/image/manager/user_image_manager_view.dart';
import 'package:youyu/modules/submod/user/detail/user_detail_binding.dart';
import 'package:youyu/modules/submod/user/detail/user_detail_view.dart';
import 'package:youyu/modules/submod/user/level/level_binding.dart';
import 'package:youyu/modules/submod/user/level/level_view.dart';
import 'package:youyu/modules/submod/user/nobility/nobility_binding.dart';
import 'package:youyu/modules/submod/user/nobility/nobility_view.dart';
import 'package:youyu/modules/submod/vip/vip_binding.dart';
import 'package:youyu/modules/submod/vip/vip_view.dart';
import 'package:youyu/modules/submod/web/web_binding.dart';
import 'package:youyu/modules/submod/web/web_view.dart';
import 'package:get/get.dart';

class OtherPages {
  ///搜索
  GetPage searchRoute = GetPage(
    name: '/search',
    bindings: [
      SearchIndexBinding(),
    ],
    page: () => SearchIndexPage(),
  );

  ///搜索 - 二级
  GetPage searchSubRoute = GetPage(
    name: '/searchSub',
    bindings: [
      SearchSubBinding(),
    ],
    page: () => SearchSubPage(),
    transition: Transition.fadeIn,
  );

  ///排行榜
  GetPage rankIndexRoute = GetPage(
    name: '/rank',
    bindings: [
      RankIndexBinding(),
    ],
    page: () => RankIndexPage(),
  );

  ///礼物说明
  GetPage giftDescRoute = GetPage(
    name: '/giftDesc',
    bindings: [
      CommonGiftDescBinding(),
    ],
    page: () => CommonGiftDescPage(),
  );

  ///好友
  GetPage friendRoute = GetPage(
    name: '/friend',
    bindings: [
      FriendBinding(),
    ],
    page: () => FriendPage(),
  );

  ///关注直播间
  GetPage followLiveRoute = GetPage(
    name: '/follow_live',
    bindings: [
      FollowLiveBinding(),
    ],
    page: () => FollowLivePage(),
  );

  ///最近访客
  GetPage visitRoute = GetPage(
    name: '/visit',
    bindings: [
      VisitBinding(),
    ],
    page: () => VisitPage(),
  );

  ///举报
  GetPage reportRoute = GetPage(
    name: '/report',
    bindings: [
      ReportBinding(),
    ],
    page: () => ReportPage(),
  );

  ///个人主页
  GetPage userDetailRoute = GetPage(
    name: '/user_detail',
    bindings: [
      UserDetailBinding(),
    ],
    page: () => UserDetailPage(),
  );

  ///等级
  GetPage levelRoute = GetPage(
    name: '/level',
    bindings: [
      LevelBinding(),
    ],
    page: () => LevelPage(),
  );

  ///爵位
  GetPage nobilityRoute = GetPage(
    name: '/nobility',
    bindings: [
      NobilityBinding(),
    ],
    page: () => NobilityPage(),
  );

  ///实名认证
  GetPage realAuthIndexRoute = GetPage(
    name: '/real_index',
    bindings: [
      RealAuthIndexBinding(),
    ],
    page: () => RealAuthIndexPage(),
  );

  ///实名认证详情
  GetPage realAuthDetailRoute = GetPage(
    name: '/real_detail',
    bindings: [
      RealAuthDetailBinding(),
    ],
    page: () => RealAuthDetailPage(),
  );

  ///青少年模式
  GetPage childrenRoute = GetPage(
    name: '/children',
    bindings: [
      ChildrenBinding(),
    ],
    page: () => ChildrenPage(),
  );

  ///青少年模式设置
  GetPage childrenPwRoute = GetPage(
    name: '/children_pw',
    bindings: [
      ChildrenPwBinding(),
    ],
    page: () => ChildrenPwPage(),
  );

  ///意见反馈
  GetPage feedBackRoute = GetPage(
    name: '/feedBack',
    bindings: [
      FeedBackBinding(),
    ],
    page: () => FeedBackPage(),
  );


  ///用户照片墙管理
  GetPage userImgManagerRoute = GetPage(
    name: '/user_img_manager',
    bindings: [
      UserImageManagerBinding(),
    ],
    page: () => UserImageManagerPage(),
  );

  ///用户编辑
  GetPage userEditRoute = GetPage(
    name: '/user_edit',
    bindings: [
      UserEditBinding(),
    ],
    page: () => UserEditPage(),
  );

  ///用户编辑子页面
  GetPage userSubEditRoute = GetPage(
    name: '/user_sub_edit',
    bindings: [
      UserEditSubBinding(),
    ],
    page: () => UserEditSubPage(),
  );

  ///商城
  GetPage shopRoute = GetPage(
    name: '/shop',
    bindings: [
      ShopBinding(),
    ],
    page: () => const ShopPage(),
  );

  ///背包
  GetPage bagRoute = GetPage(
    name: '/bag',
    bindings: [
      BagBinding(),
    ],
    page: () => const BagPage(),
  );

  ///vip
  GetPage vipRoute = GetPage(
    name: '/vip',
    bindings: [
      VipBinding(),
    ],
    page: () => VipPage(),
  );

  ///bigImage
  GetPage bigImageRoute = GetPage(
    name: '/big_image',
    bindings: [
      BigImageBinding(),
    ],
    page: () => const BigImagePage(),
    transition: Transition.noTransition,
  );

  ///web
  GetPage webRoute = GetPage(
    name: '/web',
    bindings: [
      WebBinding(),
    ],
    page: () => const WebPage(),
  );

  ///公会
  GetPage conferenceRoute = GetPage(
    name: '/conference',
    bindings: [
      ConferenceIndexBinding(),
    ],
    page: () => ConferenceIndexPage(),
  );

  ///公会详情
  GetPage conferenceDetailRoute = GetPage(
    name: '/conference_detail',
    bindings: [
      ConferenceDetailBinding(),
    ],
    page: () => ConferenceDetailPage(),
  );
}
