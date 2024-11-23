import 'dart:io';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

///下载类型
enum DownType {
  bigGifAni(1), //礼物动效
  liveBackGround(2), //背景svg
  slideGift(3), //顶部飘屏
  header(4), //头像框
  audioWheat(5); //音麦

  const DownType(this.type);

  final int type;
}

///downQueMap 的 entry
class _DownTaskEntry {
  _DownTaskEntry({required this.downType}) {
    _fileSubPath = "fileCache_${downType.type.toString()}";
  }

  // 串行队列
  final List<DownModel> _downQueue = [];

  //是否开始下载
  bool _isStartDowning = false;

  //缓存路径
  late String _fileSubPath;

  //下载类型
  final DownType downType;

  //下载状态监听
  final List<AsyncDownListener> _downListener = [];

  ///添加下载任务
  Future<File?> addTask(DownModel bean) async {
    File file = await _readFile(bean.url);
    if (file.existsSync()) {
      LogUtils.onPrint("已经下载：${file.path}", tag: "AsyncDown");
      _downSuccess(file);
      return file;
    }
    if (_downQueue.where((element) => element.url == bean.url).isNotEmpty) {
      LogUtils.onPrint("${downType.type}-${bean.url} 已存在下载任务",
          tag: "AsyncDown");
      return null;
    }
    _downQueue.add(bean);
    if (!_isStartDowning) {
      _isStartDowning = true;
      return _startDownLoad(_downQueue.first);
    }
    return null;
  }

  ///开始下载
  Future<File?> _startDownLoad(DownModel bean) async {
    try {
      var response = await Dio().get(bean.url,
          onReceiveProgress: (num received, num total) {
        /// 获取下载进度
        // double _process = double.parse((received / total).toStringAsFixed(2));
      },
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));

      /// 写入文件
      Directory storageDir = await getApplicationDocumentsDirectory();
      String storagePath = storageDir.path;
      File file = File("$storagePath/$_fileSubPath/${bean.url.hashCode}");
      if (!file.existsSync()) {
        file.createSync();
      }
      file.writeAsBytesSync(response.data);
      _downSuccess(file);
      LogUtils.onPrint("下载成功地址：${file.path}", tag: "AsyncDown");
      _downQueue.remove(bean);
      if (_downQueue.isNotEmpty) {
        _isStartDowning = true;
        _startDownLoad(_downQueue.first);
      } else {
        _isStartDowning = false;
      }
      return file;
    } on DioError catch (e) {
      LogUtils.onPrint(
          "${downType.type}-${bean.url} response.statusCode: ${e.type}",
          tag: "AsyncDown");
      Future.delayed(const Duration(milliseconds: 500), () {
        bean.repeatTime--;
        if (bean.repeatTime <= 0) {
          _downError();
          _downQueue.remove(bean);
        }
        if (_downQueue.isNotEmpty) {
          _startDownLoad(_downQueue.first);
        } else {
          _isStartDowning = false;
        }
      });
    }
    return null;
  }

  ///根据url读取本地文件
  Future<File> _readFile(String url) async {
    Directory storageDir = await getApplicationDocumentsDirectory();
    String storagePath = storageDir.path;
    var dir = Directory("$storagePath/$_fileSubPath");
    if (!dir.existsSync()) {
      // 创建文件,可选参数recursive：true表示可以创建嵌套文件夹，false表示只能创建最后一级文件夹（上一级文件不存在会报错），默认false
      dir = await dir.create(recursive: true);
    }
    return File("${dir.path}/${url.hashCode}");
  }

  ///添加下载监听
  addDownListener(AsyncDownListener listener) {
    if (!_downListener.contains(listener)) {
      _downListener.add(listener);
    }
  }

  ///移除下载监听
  removeDownListener(AsyncDownListener listener) {
    _downListener.remove(listener);
  }

  _downSuccess(File file) {
    for (var element in _downListener) {
      element.onDownLoadSuccess(downType, file);
    }
  }

  _downError() {
    for (var element in _downListener) {
      element.onDownLoadError(downType);
    }
  }
}

///异步下载服务
class AsyncDownService extends AppBaseController {
  static AsyncDownService? _instance;

  factory AsyncDownService() => _instance ??= AsyncDownService._();

  AsyncDownService._();

  //下载队列map
  final Map<int, _DownTaskEntry> _downQueMap = {};

  @override
  onInit() {
    super.onInit();
    _downQueMap[DownType.bigGifAni.type] =
        _DownTaskEntry(downType: DownType.bigGifAni);
    _downQueMap[DownType.liveBackGround.type] =
        _DownTaskEntry(downType: DownType.liveBackGround);
    _downQueMap[DownType.slideGift.type] =
        _DownTaskEntry(downType: DownType.slideGift);
    _downQueMap[DownType.header.type] =
        _DownTaskEntry(downType: DownType.header);
    _downQueMap[DownType.audioWheat.type] =
        _DownTaskEntry(downType: DownType.audioWheat);
  }

  ///添加下载任务
  addTask(DownType downType, DownModel bean) async {
    return await _downQueMap[downType.type]?.addTask(bean);
  }

  ///添加下载监听
  addDownListener(DownType downType, AsyncDownListener listener) {
    _downQueMap[downType.type]?.addDownListener(listener);
  }

  ///移除下载监听
  removeDownListener(DownType downType, AsyncDownListener listener) {
    _downQueMap[downType.type]?.removeDownListener(listener);
  }
}

///每一个任务的下载模型
class DownModel {
  DownModel({required this.url});

  //下载url，也做唯一标识
  final String url;

  //是否正在下载
  bool isDowning = false;

  //重试3次
  int repeatTime = 3;
}

///回调
mixin AsyncDownListener {
  //下载成功
  onDownLoadSuccess(DownType downType, File file);

  //下载失败
  onDownLoadError(DownType downType);
}
