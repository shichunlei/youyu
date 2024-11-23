import 'dart:async';

import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/untis_ext.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_wrapper.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_transaction_wrappers.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_receipt_manager.dart';
import 'file_write_log.dart';
import 'iap_cache.dart';
import 'jd_log.dart';

typedef IapCallback = void Function(bool isSuccess, String errorMsg);

class IOSPayment extends AppBaseController with WidgetsBindingObserver {

  /// 单例模式
  IOSPayment._();

  static IOSPayment? _instance;

  static IOSPayment get instance => getOrCreateInstance();

  static IOSPayment getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = IOSPayment._();
      return _instance!;
    }
  }

  bool hasBindAppLife = false;

  IapCache iapCache = IapCache();

  // 应用内支付实例
  final InAppPurchasePlatform iosPurchase = InAppPurchasePlatform.instance;

  // iOS订阅监听
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// 判断是否可以使用支付
  Future<bool> isAvailable() async => await iosPurchase.isAvailable();

  ///监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    jdLog(':didChangeAppLifecycleState:$state');
    if (state == AppLifecycleState.resumed) {
      //从后台切换前台，界面可见
      if (!isPaying) {
        checkUnfinishedPayment(() => null);
      }
    }
  }

  // 开始订阅 app一启动或者登录就订阅 看是否有支付完成的订单
  void startSubscription() async {
    // if (!LoginTool.isLogin()) {
    //   return;
    // }

    if (_subscription != null) {
      return;
    }
    if (!hasBindAppLife) {
      WidgetsBinding.instance.addObserver(this);
      hasBindAppLife = true;
    }
    jdLog('iap 开始订阅 -------->');
    // 支付消息订阅
    Stream purchaseStream = iosPurchase.purchaseStream;
    _subscription = purchaseStream.listen((purchaseDetailsList) {
      purchaseDetailsList.forEach(_handleReportedPurchaseState);
    }, onDone: () {
      jdLog('iap 开始订阅onDone -------->');
      // _subscription?.cancel();
      jdLog("onDone");
    }, onError: (error) {
      jdLog("error");
    }) as StreamSubscription<List<PurchaseDetails>>?;
  }

  bool isPaying = false;
  IapCallback? currentIapCallBack;

  // 开始支付  productId : 商品在苹果后台设置的id    orderId: 我们服务端生产的id
  void iosStartPay(String productId, String orderId,
      {IapCallback? iapCallback}) async {
    if (
        // !LoginTool.isLogin() ||
        productId.isEmpty ||
            orderId.isEmpty ||
            UserController.to.id.toString().isEmpty) {
      FileWriteLog.log('iap iosStartPay 参数不对 或没登录 -------->');
      iapCallback?.call(false, '参数不对 或没登录');
      return;
    }
    if (!await isAvailable()) {
      bool hasNet = await isNetWorkConnected();
      if (hasNet) {
        alertCanNotBuyDialog();
      } else {
        ToastUtils.show("没有网络");
      }
      iapCallback?.call(false, '无法支付');
      return;
    }

    checkUnfinishedPayment(() async {
      // 获取商品列表
      ProductDetailsResponse appStoreProducts =
          await iosPurchase.queryProductDetails({productId});
      if (appStoreProducts.productDetails.isNotEmpty) {
        // 发起支付 消耗商品的支付
        FileWriteLog.log('iap 发起支付productId --------> $productId');
        iosPurchase
            .buyConsumable(
          purchaseParam: PurchaseParam(
            productDetails: appStoreProducts.productDetails.first,
            applicationUserName: UserController.to.id.toString(),
          ),
        )
            .then((value) {
          if (value) {
            currentIapCallBack = iapCallback;
            // 只要能发起，就写入
            // status 0 开始支付 1 苹果回调失败 2 苹果支付成功  3服务器校验失败
            Map dataMap = {
              IapCache.kOrderId: orderId,
              IapCache.kProductId: productId,
              IapCache.kStatus: 0,
              IapCache.kUserId: UserController.to.id.toString(),
            };
            FileWriteLog.log('iap 开始支付保存的dataMap-----> ${dataMap.toString()}');
            iapCache.saveOrUpdateWithMap(dataMap);
          }
        }).catchError((err) {
          FileWriteLog.log('当前商品您有未完成的交易，请等待iOS系统核验后再次发起购买。');
          iapCallback?.call(false, '当前商品您有未完成的交易，请等待iOS系统核验后再次发起购买。');
          jdLog(err);
        });
      } else {
        iapCallback?.call(false, '没有这个商品');
        ToastUtils.show("查询商品信息失败");
      }
    });
  }

  //监听状态回调
  Future<void> _handleReportedPurchaseState(
      AppStorePurchaseDetails purchaseDetail) async {
    FileWriteLog.log(
        'iap 监听状态回调 purchaseDetail.status  --------> ${purchaseDetail.status}');
    if (purchaseDetail.status == PurchaseStatus.pending) {
      // 有订单开始支付
      FileWriteLog.log(
          'iap 监听状态回调 有订单开始支付productID--------> ${purchaseDetail.productID}');
      showCommit();
    } else {
      if (purchaseDetail.status == PurchaseStatus.error) {
        //错误
        FileWriteLog.log(
            'iap 监听状态回调 错误1  productID--------> ${purchaseDetail.productID}');
        finishTransaction(purchaseDetail);
        currentIapCallBack?.call(false, '苹果支付失败');
      } else if (purchaseDetail.status == PurchaseStatus.canceled) {
        /// 取消订单
        FileWriteLog.log(
            'iap 监听状态回调 取消订单 productID--------> ${purchaseDetail.productID}');
        currentIapCallBack?.call(false, '取消订单');
        finishTransaction(purchaseDetail);
      } else if (purchaseDetail.status == PurchaseStatus.purchased ||
          purchaseDetail.status == PurchaseStatus.restored) {
        FileWriteLog.log(
            'iap 监听状态回调 支付完成  productID--------> ${purchaseDetail.productID}');
        Map? resultMap =
            await iapCache.findWithProductID(purchaseDetail.productID);
        if (resultMap != null) {
          FileWriteLog.log(
              'iap 缓存resultMap != null  productID--------> ${purchaseDetail.productID}');

          resultMap[IapCache.kServerVerificationData] =
              purchaseDetail.verificationData.serverVerificationData;
          resultMap[IapCache.kTransactionDate] = purchaseDetail.transactionDate;
          resultMap[IapCache.kPurchaseID] = purchaseDetail.purchaseID ?? "";
          resultMap[IapCache.kStatus] = 2;
          iapCache.saveOrUpdateWithMap(resultMap);

          FileWriteLog.log(
              'iap 支付成功保存的resultMap-----> ${resultMap.toString()}');

          //已经购买   purchaseID是苹果服务器的订单id transactionIdentifier
          //      if (purchaseDetail.applicationUsername.isEmptyNullAble) {
          //        FileWriteLog.log("applicationUsername null ");
          //        /*
          // 如果某个transaction支付成功但是并没有调用finishTransaction去完成这个交易的时候，
          // 下次启动App重新监听支付队列的时候会重新调用paymentQueue:updatedTransactions:重新获取到未完成的交易，
          // 这个时候获取applicationUsername会出现nil的情况
          //
          // 目前可能场景是用户只尝试充值了一笔，收到苹果两次支付回调
          // 比如：
          // 1、不在常用区域网络或长时间未使用IAP, 则需要进行短信校验. 此时会有两次支付回调
          // 2、如果在支付进行时, 我们将App进程销毁, 支付完成再启动App, 也会有连续两次回调
          // 备注：第一次回调applicationUsername有值，第二次回调applicationUsername为空
          //   */
          //      }
          String orderId = resultMap.getStringNotNull(IapCache.kOrderId);
          if (orderId.isNotEmpty) {
            FileWriteLog.log('iap 调用后台接口,发放商品orderId-----> $orderId');

            /// 调用后台接口,发放商品
            bool success =
                await requestVerifyToServer(purchaseDetail, orderId: orderId);
            if (success) {
              FileWriteLog.log('iap 服务器验证通过-----> ');
              deliverProduct(purchaseDetail);
              currentIapCallBack?.call(true, '');
              finishTransaction(purchaseDetail);
            } else {
              // 重试几次强制删除  重新请求 或者删除
              retryOrFinishPurchase(purchaseDetail, orderId, (success) {
                if (success) {
                  currentIapCallBack?.call(true, '');
                  finishTransaction(purchaseDetail);
                  deliverProduct(purchaseDetail);
                } else {
                  int? retryCount = resultMap[IapCache.kRetryCount];
                  retryCount ??= 0;
                  if (retryCount >= 5) {
                    finishTransaction(purchaseDetail);
                    AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
                        msg: "服务器校验失败",
                        msgFontSize: 14.sp,
                        onlyCommit: true,
                        onCommit: () async {});
                  } else {
                    int currentCount = retryCount++;
                    resultMap[IapCache.kRetryCount] = currentCount;
                    iapCache.saveOrUpdateWithMap(resultMap);

                    AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
                        msg: "服务器校验失败",
                        msgFontSize: 14.sp,
                        onlyCommit: true,
                        onCommit: () async {});
                  }
                }
              });
            }
          } else {
            // 没查到订单id
            //本地数据没找到 服务端校验
            noLocalDataSendServer(purchaseDetail, (success) {
              if (success) {
                currentIapCallBack?.call(true, '');
                deliverProduct(purchaseDetail);
                FileWriteLog.log(
                    'iap finishTransaction222  productID--------> ${purchaseDetail.productID}');
                finishTransaction(purchaseDetail);
              } else {
                currentIapCallBack?.call(false, '');
                int? retryCount = resultMap[IapCache.kRetryCount];
                retryCount ??= 0;
                if (retryCount >= 5) {
                  finishTransaction(purchaseDetail);
                  AppTipDialog().showTipDialog(
                    "服务器校验失败",
                    AppWidgetTheme.light,
                    msg: "请联系客服",
                    commitBtn: "确定",
                    onlyCommit: true,
                    onCommit: () {},
                  );
                } else {
                  int currentCount = retryCount++;
                  resultMap[IapCache.kRetryCount] = currentCount;
                  iapCache.saveOrUpdateWithMap(resultMap);
                  AppTipDialog().showTipDialog(
                    "服务器校验失败",
                    AppWidgetTheme.light,
                    msg: "请确保手机网络良好 杀死app后重启app",
                    commitBtn: "确定",
                    onlyCommit: true,
                    onCommit: () {},
                  );
                }
                FileWriteLog.log(
                    'iap 本地数据没找到 服务端校验失败  productID--------> ${purchaseDetail.productID}');
              }
            });
          }
        } else {
          //本地数据没找到 服务端校验
          FileWriteLog.log(
              'iap 本地数据没找到 服务端校验  productID--------> ${purchaseDetail.productID}');
          noLocalDataSendServer(purchaseDetail, (success) {
            if (success) {
              FileWriteLog.log(
                  'iap finishTransaction333  productID--------> ${purchaseDetail.productID}');
              currentIapCallBack?.call(true, '');
              finishTransaction(purchaseDetail);
              deliverProduct(purchaseDetail);
            } else {
              currentIapCallBack?.call(false, '服务端校验失败');

              AppTipDialog().showTipDialog(
                "服务器校验失败",
                AppWidgetTheme.light,
                msg: "请联系客服",
                commitBtn: "确定",
                onlyCommit: true,
                onCommit: () {},
              );
              FileWriteLog.log(
                  'iap 本地数据没找到 服务端校验失败  productID--------> ${purchaseDetail.productID}');
            }
          });
        }
      }
      // if (purchaseDetail.pendingCompletePurchase) {
      //   finishTransaction(purchaseDetail);
      // }
    }
  }

  // 支付成功 发送商品
  deliverProduct(PurchaseDetails purchaseDetails) {
    ToastUtils.show('支付成功');
  }

  //处理校验失败逻辑 重试还是关闭
  retryOrFinishPurchase(PurchaseDetails purchaseDetails, String? orderId,
      Function(bool success) complete) async {
    bool hasNet = await isNetWorkConnected();
    if (hasNet) {
      if (orderId.isNotEmptyNullAble) {
        bool result = await requestVerifyToServer(purchaseDetails,
            orderId: orderId ?? "");
        complete(result);
      } else {
        noLocalDataSendServer(purchaseDetails, (success) {
          complete(success);
        });
      }
    } else {
      ToastUtils.show('校验支付失败');
      complete(false);
    }
  }

  // 本地没数据 发送服务端校验 可以加个参数
  noLocalDataSendServer(
      PurchaseDetails purchaseDetail, Function(bool success)? complete) async {
    bool success = await requestVerifyToServer(purchaseDetail);
    complete?.call(success);
  }

  //向服务器请求校验
  Future<bool> requestVerifyToServer(PurchaseDetails purchaseDetail,
      {String? orderId}) async {
    try {
      await request(AppApi.appleUrl, params: {
        "receipt": purchaseDetail.verificationData.serverVerificationData,
        "product_id": purchaseDetail.productID,
        "order_no": orderId
      });
    } catch (e) {
      //...
    }
/*
     orderId,
     purchaseID //苹果的订单id
                  purchaseDetail.productID,
                  purchaseDetail.verificationData.serverVerificationData,
                  purchaseDetail.transactionDate ?? ""
 */
    // 成功后删除 已经发送过商品 也是finish
    // finalTransaction(purchaseDetail);
    return Future<bool>.value(true);
  }

  //查询支付完成 没向服务端校验订单
  void checkUnfinishedPayment(Function() complete) async {
    // if (LoginTool.isNotLogin()) {
    //   complete();
    //   return;
    // }
    SKPaymentQueueWrapper()
        .transactions()
        .then((List<SKPaymentTransactionWrapper> values) async {
      if (values.isNotEmpty) {
        for (var element in values) {
          if (element.transactionState ==
              SKPaymentTransactionStateWrapper.purchased) {
            // String productId = element.payment.productIdentifier;
            String receiptData = await SKReceiptManager.retrieveReceiptData();
            AppStorePurchaseDetails detail =
                AppStorePurchaseDetails.fromSKTransaction(element, receiptData);
            // detail.applicationUsername = element.payment.applicationUsername;

            FileWriteLog.log('iap 有没完成的交易productID---->${detail.productID}');
            if (element.payment.applicationUsername?.isEmpty ?? false) {
              FileWriteLog.log('iap---> applicationUsername会出现nil');
              // SKPaymentQueueWrapper().finishTransaction(element);
              // deleteWithProductID(productId);
              // complete();
            }
            iapCache
                .findWithProductID(element.payment.productIdentifier)
                .then((Map? resultMap) {
              if (resultMap != null && resultMap.keys.isNotEmpty) {
                requestVerifyToServer(detail,
                        orderId: resultMap[IapCache.kOrderId])
                    .then((value) {
                  if (value) {
                    FileWriteLog.log(
                        'iap 重新校验成功 finishTransaction444  -------->');
                    finishTransaction(detail);
                    complete();
                  } else {
                    FileWriteLog.log('iap 重新校验失败11 -------->');
                    retryOrFinishPurchase(detail, resultMap[IapCache.kOrderId],
                        (success) {
                      if (success) {
                        FileWriteLog.log(
                            'iap 重新校验成6666 inishTransaction-------->');
                        deliverProduct(detail);
                        finishTransaction(detail);
                      } else {
                        int? retryCount = resultMap[IapCache.kRetryCount];
                        retryCount ??= 0;
                        if (retryCount >= 5) {
                          finishTransaction(detail);
                          AppTipDialog().showTipDialog(
                            "服务器校验失败",
                            AppWidgetTheme.light,
                            msg: "请联系客服",
                            commitBtn: "确定",
                            onlyCommit: true,
                            onCommit: () {},
                          );
                        } else {
                          int currentCount = retryCount++;
                          resultMap[IapCache.kRetryCount] = currentCount;
                          iapCache.saveOrUpdateWithMap(resultMap);

                          AppTipDialog().showTipDialog(
                            "服务器校验失败",
                            AppWidgetTheme.light,
                            msg: "请确保手机网络良好 杀死app后重启app",
                            commitBtn: "确定",
                            onlyCommit: true,
                            onCommit: () {},
                          );
                        }
                      }

                      complete();
                    });
                  }
                });
              } else {
                //本地数据没找到 服务端校验
                noLocalDataSendServer(detail, (success) {
                  if (success) {
                    deliverProduct(detail);
                    FileWriteLog.log('iap finishTransaction666  -------->');
                    finishTransaction(detail);
                  } else {
                    FileWriteLog.log('iap 本地数据没找到 服务端校验失败  -------->');
                  }
                  complete();
                });
              }
            });
          }
        }
      } else {
        complete();
      }
    });
  }

  // 关闭交易
  void finishTransaction(PurchaseDetails purchaseDetails) async {
    await iosPurchase.completePurchase(purchaseDetails);
    iapCache.deleteWithProductID(purchaseDetails.productID);
    hiddenCommit();
    FileWriteLog.log('iap 关闭交易 finishTransaction  -------->');
  }

  //  退出登录 关闭监听
  stopIapListen() async {
    _subscription?.cancel();
    _subscription = null;
    if (hasBindAppLife) {
      WidgetsBinding.instance.removeObserver(this);
      hasBindAppLife = false;
    }
  }

  void alertCanNotBuyDialog() {
    AppTipDialog().showTipDialog(
      "访问受限",
      AppWidgetTheme.light,
      msg: "你的手机关闭了“应用内购买”，请在“设置-屏幕使用时间-内容和因素访问限制”里重新打开该选项后尝试。",
      commitBtn: "确定",
      onlyCommit: true,
      onCommit: () {},
    );
  }

  /// 判断网络是否连接
  Future<bool> isNetWorkConnected() async {
    var connectResult = await (Connectivity().checkConnectivity());
    return connectResult != ConnectivityResult.none;
  }
}
