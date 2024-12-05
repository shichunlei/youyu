import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:youyu/models/gift_game.dart';

///动画子类型
enum GameSubViewType { primary, advanced }

class GameService {
  static GameService? _instance;

  factory GameService() => _instance ??= GameService._();

  GameService._();

  ///转盘动画相关
  var isWheelGameAniOpen = true.obs;
  GiftGame? primaryModel;
  GiftGame? advancedModel;

  //普通
  List<ui.Image> primaryImages = [];
  List<String> primaryPrices = [];

  //高级
  List<ui.Image> advancedImages = [];
  List<String> advancedPrices = [];

  ///加载数据
  loadListData(GameSubViewType type) async {
    GiftGame? model =
        (type == GameSubViewType.primary ? primaryModel : advancedModel);
    if (model != null) {
      List<String> prices =
          model.showList?.map((e) => e.unitPrice.toString()).toList() ?? [];
      List<String> imageUrls =
          model.showList?.map((e) => e.img.toString()).toList() ?? [];

      List<Future<ui.Image>> downloadFutures = imageUrls.map((url) {
        return _downloadAndDecodeImage(url);
      }).toList();
      await _loadData(downloadFutures, prices, type);
    }
  }

  _loadData(downloadFutures, prices, type) async {
    try {
      final List<ui.Image> images = await Future.wait(downloadFutures);
      if (type == GameSubViewType.primary) {
        primaryImages.clear();
        primaryImages.addAll(images);
        primaryPrices.clear();
        primaryPrices.addAll(prices);
      } else {
        advancedImages.clear();
        advancedImages.addAll(images);
        advancedPrices.clear();
        advancedPrices.addAll(prices);
      }
    } catch (e) {
      print('Error downloading images: $e');
    }
  }

  Future<ui.Image> _downloadAndDecodeImage(String url) async {
    try {
      final dio = Dio();
      // 获取网络图片字节
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,  // 直接获取字节数据
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // 使用 decodeImageFromList 解码为 ui.Image
        final Completer<ui.Image> completer = Completer();
        ui.decodeImageFromList(Uint8List.fromList(response.data!), (ui.Image image) {
          completer.complete(image);
        });
        // 返回解码后的 ui.Image
        return completer.future;
      } else {
        throw Exception('Failed to load image: $url, status: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('Error downloading image: $e\nStack: $stack');
      throw Exception('Failed to load image: $url, error: $e');
    } finally {
      // 清理资源
    }
  }
}
