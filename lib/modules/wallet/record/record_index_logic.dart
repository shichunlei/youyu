import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/coin_record.dart';
import 'package:youyu/models/diamond_record.dart';
import 'package:youyu/models/withdraw_record.dart';
import 'package:youyu/modules/wallet/index/wallet_index_logic.dart';
import 'package:youyu/widgets/app/actionsheet/app_date_picker.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:get/get.dart';
import 'model/record_list_model.dart';
import 'package:youyu/utils/time_utils.dart' as baseTime;

class RecordIndexLogic extends AppBaseController {
  MenuModel? menuModel;
  String time = "";
  int timestamp = 0;

  int _pageIndex = PageConfig.start;

  List<RecordListModel> dataList = [];

  @override
  void onInit() {
    super.onInit();

    menuModel = Get.arguments as MenuModel;
    DateTime dateTime = DateTime.now();
    time = "${dateTime.year.toString()}年${dateTime.month.toString()}月";
    timestamp =
        int.parse((DateTime.now().millisecondsSinceEpoch ~/ 1000).toString());
    loadData();
  }

  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  showTimePicker() {
    AppDataPicker.showDataPicker2(
      Get.context!,
      mode: DateMode.YM,
      onConfirm: (dateTime) {
        time = "${dateTime.year.toString()}年${dateTime.month.toString()}月";
        DateTime dataTime = DateTime(dateTime.year ?? 0, dateTime.month ?? 0);
        timestamp =
            int.parse((dataTime.millisecondsSinceEpoch ~/ 1000).toString());
        setSuccessType();
        loadData();
      },
    );
  }

  _fetchList(int page) {
    String url = '';
    switch (menuModel?.type as WalletListType) {
      case WalletListType.rechargeRecord:
        url = AppApi.rechargeRecordeUrl;
        break;
      case WalletListType.withdrawRecord:
        url = AppApi.withDrawListUrl;
        break;
      case WalletListType.mochaRecord:
        url = AppApi.coinListUrl;
        break;
      case WalletListType.diamondRecord:
        url = AppApi.diamondListUrl;
        break;
      default:
        //...
        break;
    }
    request(url, params: {
      'time': timestamp,
      'page': page,
      'limit': PageConfig.limit,
    }).then((value) {
      //1.改变刷新状态
      refreshController.refreshCompleted();
      //2.设置索引
      if (page == PageConfig.start) {
        dataList.clear();
      }
      _pageIndex = page + 1;
      //3.设置数据
      List<dynamic> list;
      if ((menuModel?.type as WalletListType) ==
          WalletListType.rechargeRecord) {
        list = value.data['list']['data'];
      } else {
        list = value.data['data'];
      }
      for (Map<String, dynamic> map in list) {
        switch (menuModel?.type as WalletListType) {
          case WalletListType.rechargeRecord:
            RecordListModel model = RecordListModel();
            model.title = map['type'] == 1 ? "支付宝支付" : "微信支付";
            model.time =  baseTime.TimeUtils.customStampStr(
                timestamp: map['create_time'] ?? 0,
                date: "YY-MM-DD hh:mm:ss",
                toInt: false);
            model.rightValue = map['amount'];
            model.isIn = true;
            dataList.add(model);
            break;
          case WalletListType.withdrawRecord:
            {
              WithDrawRecord entity = WithDrawRecord.fromJson(map);
              RecordListModel model = RecordListModel();
              model.title = "提现";
              model.time = baseTime.TimeUtils.customStampStr(
                  timestamp: int.parse(entity.createTime ?? '0'),
                  date: "YY-MM-DD hh:mm:ss",
                  toInt: false);
              model.rightValue = "¥${entity.money}";
              ////0 未处理 1 通过 2未通过
              model.withDrawState = entity.state ?? 0;
              if (model.withDrawState == 1) {
                model.rightSubValue = "已到账";
              } else if (model.withDrawState == 2) {
                model.rightSubValue = "已驳回";
              } else if (model.withDrawState == 0) {
                model.rightSubValue = "审核中";
              }
              dataList.add(model);
            }
            break;
          case WalletListType.mochaRecord:
            {
              CoinRecord entity = CoinRecord.fromJson(map);
              RecordListModel model = RecordListModel();
              model.title = entity.desc;
              model.time = baseTime.TimeUtils.customStampStr(
                  timestamp: entity.createTime ?? 0,
                  date: "YY-MM-DD hh:mm:ss",
                  toInt: false);
              model.rightValue = entity.number;
              if (entity.number?.contains("-") == true) {
                model.isIn = false;
              } else {
                if (!entity.number!.contains("+")) {
                  model.rightValue = "+${entity.number}";
                }
                model.isIn = true;
              }
              dataList.add(model);
            }
            break;
          case WalletListType.diamondRecord:
            {
              DiamondRecord entity = DiamondRecord.fromJson(map);
              RecordListModel model = RecordListModel();
              model.title = entity.desc;
              model.time = baseTime.TimeUtils.customStampStr(
                  timestamp: entity.createTime ?? 0,
                  date: "YY-MM-DD hh:mm:ss",
                  toInt: false);
              model.rightValue = entity.number;
              if (entity.number?.contains("-") == true) {
                model.isIn = false;
              } else {
                if (!entity.number!.contains("+")) {
                  model.rightValue = "+${entity.number}";
                }
                model.isIn = true;
              }
              dataList.add(model);
            }

            break;
          default:
            //...
            break;
        }
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
    }).catchError((e) {
      refreshController.refreshCompleted();
      if (dataList.isEmpty) {
        setErrorType(e);
      } else {
        setIsLoading = false;
      }
    });
  }

  @override
  void pullRefresh() {
    super.pullRefresh();
    _fetchList(PageConfig.start);
  }

  @override
  void loadMore() {
    super.loadMore();
    _fetchList(_pageIndex);
  }

  @override
  void reLoadData() {
    super.reLoadData();
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }
}
