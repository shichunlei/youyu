enum AppFontType {
  ys(name: "ys"),
  bdt(name: "bdt"),
  nunito(name: "nunito");

  const AppFontType({required this.name});

  final String name;
}

class AppResource {
  static AppResource? _instance;

  factory AppResource() => _instance ??= AppResource._();

  AppResource._();

  static String _getCommon(String name, {String format = 'png'}) {
    return 'assets/common/$name.$format';
  }

  static String _getLive(String name, {String format = 'png'}) {
    return 'assets/live/$name.$format';
  }

  static String getSvga(String name, {String format = 'svga'}) {
    return 'assets/svga/$name.$format';
  }

  static String getGif(String name, {String format = 'gif'}) {
    return 'assets/gif/$name.$format';
  }

  static String _getGameWheel(String name, {String format = 'png'}) {
    return 'assets/game/wheel/$name.$format';
  }

  ///font
  AppFontType ys = AppFontType.ys;

  AppFontType bdt = AppFontType.bdt;

  AppFontType nunito = AppFontType.nunito;

  ///common
  //启动图
  String get splash => _getCommon("splash");

  //返回按钮
  String get back => _getCommon("ic_back");

  String get smallBack => _getCommon("ic_small_back");

  String get blackBack => _getCommon("ic_black_back");

  //空白试图
  String get empty => _getCommon("ic_empty");

  String get conferenceEmpty => _getCommon("ic_conference_img");

  //logo
  String get bigLogo => _getCommon("ic_big_logo");

  String get aliBg => _getCommon("ic_ali_bg");

  String get aliBtn => _getCommon("ic_ali_btn");

  // 登录页面顶部背景
  String get loginTopBg => _getCommon("ic_login_top_bg");

  String get commonTopBg => _getCommon("ic_common_top_bg");

  String get meTopBg => _getCommon("ic_me_top_bg");

  //默认头像
  String get defaultHead => _getCommon("ic_defalut_head");

  //third
  String get qq => _getCommon("ic_qq");

  String get wx => _getCommon("ic_wx");

  //down
  String get down => _getCommon("ic_down");

  //check
  String get check => _getCommon("ic_check");

  String get unCheck => _getCommon("ic_un_check");

  String get check2 => _getCommon("ic_check2");

  String get unCheck2 => _getCommon("ic_un_check2");

  //sel
  String get sel => _getCommon("ic_sel");

  String get unSel => _getCommon("ic_un_sel");

  String get unGraySel => _getCommon("ic_un_gray_sel");

  //photo
  String get smallPhoto => _getCommon("ic_photo");

  String get smallPhoto2 => _getCommon("ic_photo2");

  //搜索
  String get search => _getCommon("ic_search");

  //男/女
  String get boy => _getCommon("ic_boy");

  String get girl => _getCommon("ic_girl");

  //火
  String get fir => _getCommon("ic_fire");

  //箭头
  String get arrow1 => _getCommon("ic_arrow_1");

  String get arrow2 => _getCommon("ic_arrow_2");

  //del
  String get del => _getCommon("ic_del");

  String get imgDel => _getCommon("ic_img_del");

  //靓号
  String get lh => _getCommon("ic_liang");

  String get fancyNumberBg => _getCommon("fancy_number_bg");

  //币icon
  String get coin1 => _getCommon("ic_coin_icon1");

  String get coin2 => _getCommon("ic_coin_icon2");

  String get coin3 => _getCommon("ic_coin_icon3");

  String get coin4 => _getCommon("ic_coin_icon4");

  //复制
  String get copy => _getCommon("ic_copy");

  //上箭头
  String get up => _getCommon("ic_up");

  //签名标签
  String get signTip => _getCommon("ic_sign_tip");

  //支付
  String get aliPay => _getCommon("ic_ali_pay");

  String get wxPay => _getCommon("ic_wx_pay");

  String get aliPay2 => _getCommon("ic_ali_pay2");

  String get wxPay2 => _getCommon("ic_wx_pay2");

  //waring
  String get warning => _getCommon("ic_warinng");

  //mask img
  String get maskImg1 => _getCommon("mask_img1");

  String get maskImg2 => _getCommon("mask_img2");

  String get maskImg3 => _getCommon("mask_img3");

  //图片添加/删除
  String get imgAdd => _getCommon("ic_img_add");

  String get imgDarkAdd => _getCommon("ic_img_dark_add");

  String get imDarkSub => _getCommon("ic_img_dark_sub");

  //分享
  String get share => _getCommon("ic_share");

  //更多
  String get more => _getCommon("ic_more");

  String get more2 => _getCommon("ic_more2");

  //qa
  String get qa => _getCommon("ic_qa");

  //键盘
  String get kb => _getCommon("ic_kb_icon");

  //关闭
  String get close => _getCommon("ic_close");

  //logo
  String get manLogo => _getCommon("ic_man_logo");

  ///tab
  String get homeTab => _getCommon("ic_home_tab");

  String get homeSelTab => _getCommon("ic_home_sel_tab");

  String get msgTab => _getCommon("ic_msg_tab");

  String get mgsSelTab => _getCommon("ic_msg_sel_tab");

  String get findTab => _getCommon("ic_find_tab");

  String get findSelTab => _getCommon("ic_find_sel_tab");

  String get mineTab => _getCommon("ic_mine_tab");

  String get mineSelTab => _getCommon("ic_mine_sel_tab");

  ///home
  String get homeTabLine => _getCommon("ic_tab_bl");

  String get homeLiveCreateLogo => _getCommon("ic_create_live_logo");

  String get homeRankLogo => _getCommon("ic_rank_logo");

  String get homeSearchLogo => _getCommon("ic_home_search_logo");

  String get homeLock => _getCommon("ic_home_lock");

  String get homeAmusementLogo => _getCommon("ic_amusement_logo");

  String get homeMarkingLogo => _getCommon("ic_marking_logo");

  String get homeSingleLogo => _getCommon("ic_single_logo");

  String get homeTag1 => _getCommon("ic_home_tag1");

  String get homeFirTag => _getCommon("ic_home_fir_tag");

  String get homeRecommendTag => _getCommon("ic_home_recommend_tag");

  String get homeFirstTag => _getCommon("ic_home_first_tag");

  String get homeRoomUser => _getCommon("ic_room_user");

  String get homeRoomHeat => _getCommon("ic_home_room_heat");

  ///rank
  String get rankTopBg => _getCommon("ic_rank_top_bg");

  String get rank1 => _getCommon("ic_rank_1");

  String get rank2 => _getCommon("ic_rank_2");

  String get rank3 => _getCommon("ic_rank_3");

  String get rankCpTopBg => _getCommon("ic_ranking_cp_top_bg");

  String get rankCpBg => _getCommon("ic_ranking_cp_bg");

  String get rankCp1 => _getCommon("ic_ranking_champion");

  String get rankCp2 => _getCommon("ic_ranking_second_place");

  String get rankCp3 => _getCommon("ic_ranking_third_place");

  ///live
  String get liveHot => _getLive("ic_live_hot");

  String get liveMore => _getLive("ic_live_more");

  String get liveNotice => _getLive("ic_live_notice");

  String get liveSeatBg => _getLive("ic_live_seat_bg");

  String get liveSeatSofa => _getLive("ic_live_seat_sofa");

  String get liveSeatNormalSofa => _getLive("ic_live_seat_normal_sofa");

  String get liveSeatLock => _getLive("ic_live_seat_lock");

  String get livePwLock => _getLive("ic_live_pw_lock");

  String get liveDBg => _getLive("live_d_bg");

  String liveSeat(int index) {
    return _getLive("live_seat_$index");
  }

  String get liveMsgBtn => _getLive("ic_live_msg_btn");

  String get liveSetBtn => _getLive("ic_live_set_btn");

  String get liveGiftBtn => _getLive("ic_live_gift_btn");

  String get liveEmoji => _getLive("ic_live_emoji");

  String get liveIsMute => _getLive("ic_live_is_mute");

  String get liveUnMute => _getLive("ic_live_un_mute");

  String get liveAudioOpen => _getLive("ic_live_audio_open");

  String get liveAudioClose => _getLive("ic_live_audio_close");

  String get liveMoreClose => _getLive("ic_live_cloase");

  String get liveWindowBtn => _getLive("ic_live_window_btn");

  String get liveReport => _getLive("ic_live_report");

  String get liveWhiteSz => _getLive("ic_live_white_sz");

  String get liveGraySz => _getLive("ic_live_gray_sz");

  String get liveSlideGift => _getLive("ic_live_slide_gift");

  String get liveVipBg => _getLive('ic_live_vip_bg');

  //user card
  String get liveUserCardChat => _getLive('live_use_card_chat');

  String get liveUserCardAdd => _getLive('live_use_card_add');

  String get liveUserCardGift => _getLive('live_use_card_gift');

  //bottom more
  String get liveBMore1 => _getLive('live_b_more_1');

  String get liveBMore2 => _getLive('live_b_more_2');

  String get liveBMore3 => _getLive('live_b_more_3');

  String get liveBMore4 => _getLive('live_b_more_4');

  String get liveBMore5 => _getLive('live_b_more_5');

  String get liveBMore6 => _getLive('live_b_more_6');

  String get liveBMore7 => _getLive('live_b_more_7');

  String get liveMLAll => _getLive('ic_live_ml_all');

  String get liveMute => _getLive('ic_live_mute_off');

  String get liveZc => _getLive('ic_live_zc');

  String get livePAdd => _getCommon('ic_live_p_add');

  String get livePSub => _getCommon('ic_live_p_sub');

  //share
  String get liveShareWx => _getLive('live_share_wx');

  String get liveShareWxFriend => _getLive('live_share_wx_friend');

  String get liveShareQQ => _getLive('live_share_qq');

  String get liveShareQQSpace => _getLive('live_share_qq_space');

  String get liveShareMocha => _getLive('live_share_mocha');

  String get liveApplyWheat => _getLive('ic_live_apply_wheat');

  String get liveMarkingState1 => _getLive('live_marking_state1');

  String get liveMarkingState2 => _getLive('live_marking_state2');

  String get liveMarkingState3 => _getLive('live_marking_state3');

  String get liveMarkingBlue => _getLive('live_marking_blue');

  String get liveMarkingRed => _getLive('live_marking_red');

  String get liveMarkingStart => _getLive('live_marking_start');

  String get liveMarkingEnd => _getLive('live_marking_end');

  String get liveMarkingTime => _getLive('live_marking_time');

  String get liveMarkingRelation => _getLive('live_marking_bg_relation');

  String get liveMarkingAmd => _getLive('live_marking_amd');

  String get liveHeart1 => _getLive('live_heart_1');

  String get liveHeart2 => _getLive('live_heart_2');

  String get liveHeart3 => _getLive('live_heart_3');

  String get liveHeart4 => _getLive('live_heart_4');

  String get liveWorldMsgBg => _getLive('live_world_im_bg');

  String get liveWorldMsgButton => _getLive('live_world_msg_button');

  String get liveWorldMsgSpaker => _getLive('live_world_im_spaker');

  String get liveWorldMsgNullAvatar => _getLive('live_world_msg_null_avatar');

  String get liveUserCardRelationBg => _getLive('live_usercard_relation_bg');

  String get liveUserCardRelationLine =>
      _getLive('live_usercard_relation_line');

  String get liveBarFlirtAll => _getLive("live_bar_flirt_all");

  ///mine
  String get mineVipLeft => _getCommon("ic_mine_vip_left");

  String get mineVipBanner => _getCommon("ic_mine_vip_banner");

  String get liveRelationEmpty => _getCommon('ic_relation_empty');

  static String getDynamicRelationCard(int index) {
    return _getCommon('relation_card_${index + 1}');
  }

  String get mineRelationBg => _getCommon('relation_bg');

  String get mineRelationCpBg1 => _getCommon('relation_cp_bg_1');

  String get mineRelationCpBg2 => _getCommon('relation_cp_bg_2');

  String get mineRelationCpBg3 => _getCommon('relation_cp_bg_3');

  //core
  String get mineJwIcon => _getCommon("ic_mine_jw_icon");

  String get mineLevelIcon => _getCommon("ic_mine_level_icon");

  String get mineWalletIcon => _getCommon("ic_mine_wallet_icon");

  //func
  String get mineBagF => _getCommon("ic_mine_bag_f");

  String get mineTaskF => _getCommon("ic_mine_task_f");

  String get mineRoomF => _getCommon("ic_mine_room_f");

  String get mineShopF => _getCommon("ic_mine_shop_f");

  String get mineConferenceF => _getCommon("ic_mine_conference_f");

  //item
  String get mineSetItem => _getCommon("ic_mine_set_item");

  String get mineFeedItem => _getCommon("ic_mine_feed_item");

  String get mineSItem => _getCommon("ic_mine_s_item");

  String get mineInviteItem => _getCommon("ic_mine_invite_item");

  String get mineChildrenItem => _getCommon("ic_mine_children_item");

  String get mineRealItem => _getCommon("ic_mine_real_item");

  ///wallet
  String get walletDiamond => _getCommon("ic_wallet_diamond");

  String get walletMocha => _getCommon("ic_wallet_mocha");

  String get walletWithDraw => _getCommon("ic_wallet_withdraw");

  String get walletWithGift => _getCommon("ic_wallet_gift");

  String get walletWithRecharge => _getCommon("ic_wallet_recharge");

  String get walletAccountChange => _getCommon("ic_wallet_charge");

  ///User
  //vip
  String get vip => _getCommon("ic_vip");

  String get svip => _getCommon("ic_svip");

  //detail
  String get userChat => _getCommon("ic_user_chat");

  String get userFocus => _getCommon("ic_user_focus");

  String get userImgAdd => _getCommon("ic_user_img_add");

  //nobility
  String get userNobility1 => _getCommon("nobility_1");

  String get userNobility2 => _getCommon("nobility_2");

  String get userNobility3 => _getCommon("nobility_3");

  String get userNobility4 => _getCommon("nobility_4");

  String get userNobility5 => _getCommon("nobility_5");

  String get userNobility6 => _getCommon("nobility_6");

  String get userNobility7 => _getCommon("nobility_7");

  String get nobilityEquity1 => _getCommon("nobility_equity1");

  String get nobilityEquity2 => _getCommon("nobility_equity2");

  String get nobilityEquity3 => _getCommon("nobility_equity3");

  String get nobilityEquity4 => _getCommon("nobility_equity4");

  String get nobilityEquity5 => _getCommon("nobility_equity5");

  String get nobilityEquity6 => _getCommon("nobility_equity6");

  String get nobilityEquityTitle => _getCommon("ic_equity_title");

  String get nobilityBg => _getCommon("ic_nobility_bg");

  //task
  String get task1 => _getCommon("ic_task_1");

  String get task2 => _getCommon("ic_task_2");

  String get task3 => _getCommon("ic_task_3");

  String get task4 => _getCommon("ic_task_4");

  String get task5 => _getCommon("ic_task_5");

  ///shop
  String get shopHeadBorder => _getCommon("ic_zb_t");

  ///vip
  String get vipTopBg => _getCommon("ic_vip_top_bg");

  //svip
  String get vipSV => _getCommon("ic_svip_v");

  String get vipSFunc1 => _getCommon("ic_svip_f_1");

  String get vipSFunc2 => _getCommon("ic_svip_f_2");

  String get vipSFunc3 => _getCommon("ic_svip_f_3");

  String get vipSFunc4 => _getCommon("ic_svip_f_4");

  String get vipSP1 => _getCommon("ic_svip_p1");

  String get vipST1 => _getCommon("ic_svip_t1");

  String get vipST2 => _getCommon("ic_svip_t2");

  //vip
  String get vipV => _getCommon("ic_vip_v");

  String get vipFunc1 => _getCommon("ic_vip_f_1");

  String get vipFunc2 => _getCommon("ic_vip_f_2");

  String get vipFunc3 => _getCommon("ic_vip_f_3");

  String get vipFunc4 => _getCommon("ic_vip_f_4");

  String get vipP1 => _getCommon("ic_vip_p1");

  String get vipT1 => _getCommon("ic_vip_t1");

  String get vipT2 => _getCommon("ic_vip_t2");

  ///discover
  String get disAdd => _getCommon("ic_dis_add");

  String get disNotify => _getCommon("ic_dis_notifiy");

  String get disComment => _getCommon("ic_dis_commit");

  String get disUnLike => _getCommon("ic_dis_un_like");

  String get disLike => _getCommon("ic_dis_like");

  String get disSmallProgress => _getCommon("ic_dis_small_progress");

  String get disSmallPlay => _getCommon("ic_dis_small_play");

  String get disSmallPause => _getCommon("ic_dis_small_pause");

  String get disAt => _getCommon("ic_dis_at");

  String get disEmoji => _getCommon("ic_dis_emoji");

  String get disRecord => _getCommon("ic_dis_record");

  String get disAudioBack => _getCommon("ic_dic_audio_back");

  String get disAudioFinish => _getCommon("ic_dic_audio_finish");

  String get disAudioIcon => _getCommon("ic_dis_audio_icon");

  String get disImgIcon => _getCommon("ic_dis_img_icon");

  ///message
  String get msgUnreadClear => _getCommon("ic_clear");

  String get msgAudio => _getCommon("ic_msg_audio");

  String get msgImg => _getCommon("ic_msg_img");

  String get msgCamera => _getCommon("ic_img_camera");

  String get msgGift => _getCommon("ic_msg_gift");

  String get msgOfficialNotice => _getCommon("ic_official_notice");

  String get msgOfficialSystem => _getCommon("ic_official_system");

  ///游戏 - 转盘
  String get gameWheelTab1 => _getGameWheel("ic_wheel_tab_1");
  String get gameWheelTab2 => _getGameWheel("ic_wheel_tab_2");

  String get gameWheelAniOpen => _getGameWheel("ic_wheel_ani_open");
  String get gameWheelAniClose => _getGameWheel("ic_wheel_ani_close");
  String get gameWheelBg => _getGameWheel("ic_wheel_bg");
  String get gameWheelCoinBg => _getGameWheel("ic_wheel_coin_bg");
  String get gameWheelRight => _getGameWheel("ic_wheel_right");
  String get gameWheelCenter => _getGameWheel("ic_wheel_center");

  String get gameWheelCircle1 => _getGameWheel("ic_wheel_circle_1");
  String get gameWheelCircle2 => _getGameWheel("ic_wheel_circle_2");

  String get gameWheelInnerCircle1 => _getGameWheel("ic_wheel_inner_circle_1");
  String get gameWheelInnerCircle2 => _getGameWheel("ic_wheel_inner_circle_2");

  String get gameWheelPao => _getGameWheel("ic_wheel_pao");
  String get gameWheelRule => _getGameWheel("ic_wheel_rule");

  String get gameWheelCoinLeft1 => _getGameWheel("ic_wheel_coin_left_1");
  String get gameWheelCoinLeft2 => _getGameWheel("ic_wheel_coin_left_2");

  String get gameWheelCoinCenter1 => _getGameWheel("ic_wheel_coin_center_1");
  String get gameWheelCoinCenter2 => _getGameWheel("ic_wheel_coin_center_2");

  String get gameWheelCoinRight1 => _getGameWheel("ic_wheel_coin_right_1");
  String get gameWheelCoinRight2 => _getGameWheel("ic_wheel_coin_right_2");

  String get gameWheelRuleBg => _getGameWheel("ic_wheel_rule_bg");

  String get gameWheelCountBg => _getGameWheel("ic_wheel_count_bg");
  String get gameWheelTaBg => _getGameWheel("ic_wheel_ta_bg");
  String get gameWheelBtn => _getGameWheel("ic_wheel_btn");
  String get gameWheelItemBg => _getGameWheel("ic_wheel_item_bg");
}
