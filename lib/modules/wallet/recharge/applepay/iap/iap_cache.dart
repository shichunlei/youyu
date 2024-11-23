import 'dart:convert';

import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/utils/untis_ext.dart';

import 'file_write_log.dart';
import 'jd_cache.dart';

class IapCache {
  static const String kOrderId = 'orderId';
  static const String kProductId = 'productId';
  // status 0 开始支付 1 苹果回调失败 2 苹果支付成功  3服务器校验失败
  static const String kStatus = 'status';
  static const String kUserId = 'applicationUsername';

  // 支付成功后的key
  static const String kServerVerificationData = 'serverVerificationData';
  static const String kTransactionDate = 'transactionDate';
  static const String kPurchaseID = 'purchaseID';
  // 重试次数
  static const String kRetryCount = 'kRetryCount';

  writeStorage(String key, String value) {
    JDCache.setString(key, value);
  }

  String readStorage(String key) {
    return JDCache.getString(key) ?? '';
  }

  /*
    {
        "真实的userId" : {
        "productId1" : {},
        "productId2" : {},
        }
    }
     */
  saveOrUpdateWithMap(Map map) {
    String userId = 'userId';
    String mapProductId = map.getStringNotNull(kProductId);
    if (userId.isEmpty || mapProductId.isEmpty) {
      FileWriteLog.log('saveOrUpdateWithMap1 ------>');
      return;
    }
    String? cacheString = readStorage(prefixIapKey(userId));
    if (cacheString.isNotEmptyNullAble) {
      Map? userIdMap = jsonDecode(cacheString);
      if (userIdMap is Map && userIdMap[userId] is Map) {
        Map productMap = userIdMap[userId];
        Map? oldProductMap = productMap[mapProductId];
        oldProductMap ??= {};
        oldProductMap.addAll(map);
        productMap[mapProductId] = oldProductMap;
        FileWriteLog.log('save userIdMap3 ------> $userIdMap');
        String encodeString = jsonEncode(userIdMap);
        writeStorage(prefixIapKey(userId), encodeString);
      } else {
        Map userIdMap = {
          userId: {mapProductId: map},
        };
        FileWriteLog.log('save userIdMap22-2 ------> $userIdMap');
        String encodeString = jsonEncode(userIdMap);
        writeStorage(prefixIapKey(userId), encodeString);
      }
    } else {
      Map userIdMap = {
        userId: {mapProductId: map},
      };
      FileWriteLog.log('save userIdMap33-2 ------> $userIdMap');
      String encodeString = jsonEncode(userIdMap);
      writeStorage(prefixIapKey(userId), encodeString);
    }
  }

  prefixIapKey(String key) {
    return 'iap_$key';
  }

  //删除某个id的数据
  deleteWithProductID(String productId) {
    if (productId.isEmpty) {
      return;
    }
    String userId = UserController.to.id.toString();
    String cacheString = readStorage(prefixIapKey(userId));
    if (cacheString.isNotEmpty) {
      Map userIdMap = jsonDecode(cacheString);
      Map productMap = userIdMap[userId];
      productMap.remove(productId);
      writeStorage(prefixIapKey(userId), jsonEncode(userIdMap));
    }
  }

  //查询
  Future<Map?> findWithProductID(String productId) async {
    if (productId.isEmpty) {
      return null;
    }
    String userId =  UserController.to.id.toString();
    String resultString = readStorage(prefixIapKey(userId));
    if (resultString.isNotEmpty) {
      try {
        Map? userIdMap = jsonDecode(resultString);
        Map? productMap = userIdMap?[userId];
        Map? targetMap = productMap?[productId];
        return targetMap;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
