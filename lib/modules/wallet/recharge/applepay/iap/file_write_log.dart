import 'dart:io';

import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/utils/date_format.dart';
import 'package:youyu/utils/untis_ext.dart';
import 'package:path_provider/path_provider.dart';
import 'file_tool.dart';
import 'jd_log.dart';

class FileWriteLog {
  FileWriteLog._() {
    createDirectory();
  }
  static FileWriteLog? _instance;
  static FileWriteLog get instance => _getOrCreateInstance();
  static FileWriteLog _getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = FileWriteLog._();
      return _instance!;
    }
  }

  File? currentFile;
  static bool isFirst = true;

  static log(String content) {
    if (isFirst) {
      isFirst = false;
      FileWriteLog.instance
          .writeFile('-----------------app启动 日志开始-----------------------\n '
          'UserId--->${UserController.to.id}\n $content');
    } else {
      FileWriteLog.instance.writeFile(content);
    }
  }

  // 写入一次 文件才会生成
  writeFile(String content) async {
    if (fileName.isNotEmpty) {
      try {
        jdLog('写入文件内容---->$content');
        IOSink sink = currentFile!.openWrite(mode: FileMode.append);
        sink.writeln(
            '$content ---- 时间 ${formatFullInfo(DateTime.now())}');
        await sink.flush();
        await sink.close();
      } catch (e) {
        jdLog('写入异常----> $e');
      }
    }
  }

  String fileType = '.txt';

  Future<String> readFile() async {
    try {
      bool exist = await FileTool.fileExists(fileName);
      if (!exist) {
        jdLog('文件不存在');
        return '';
      }
      File file = File(fileName);
      String contents = await file.readAsString();
      jdLog('read 内容----> $contents');
      return contents;
    } catch (e) {
      return '';
    }
  }

  String fileName = '';

  createFileName() {
    if (fileName.isNotEmptyNullAble) {
      return fileName;
    }
    var time = DateTime.now();
    // 一天创建一个日志文件 半个月前的日志文件删除
    String name = formatDateTime(time);
    fileName = '$currentDirectory/$name$fileType';
    currentFile = File(fileName);
    return fileName;
  }

  String currentDirectory = '';

  void createDirectory() async {
    // 创建Directory对象
    Directory documentPath = await getApplicationDocumentsDirectory();
    currentDirectory = '${documentPath.path}/jdLog';
    Directory directory = Directory(currentDirectory);
    // 检查目录是否存在，如果不存在，则创建目录
    if (!await directory.exists()) {
      // 设置recursive为true以确保创建任何必要的父目录
      await directory.create(recursive: true);
      jdLog('Directory created successfully!');
    } else {
      jdLog('Directory already exists.');
    }
    createFileName();
    deleteOldFiles();
  }

  showFileList() {
    FileTool.listFilesInDirectory(currentDirectory).then((List<String> value) {
      jdLog('当前文件列表----$value');
    });
  }

  deleteAllFiles() {
    FileTool.listFilesInDirectory(currentDirectory).then((List<String> value) {
      value.mapIndex((index, element) {
        FileTool.deleteFile(element);
      });
    });
  }

  deleteOldFiles() {
    FileTool.listFilesInDirectory(currentDirectory).then((List<String> value) {
      var nowTime = DateTime.now();
      value.mapIndex((index, element) {
        try {
          List<String> parts = element.split('/'); // 使用 '/' 分割路径
          // 获取最后一段路径
          String lastSegment = parts.isNotEmpty ? parts.last : '';
          if (lastSegment.endsWith(fileType)) {
            lastSegment = lastSegment.substring(0, lastSegment.length - 4);
          }
          // jdLog('获取的文件名字22------$lastSegment');
          DateTime? time = parse(lastSegment);
          if (time is DateTime) {
            Duration difference = time.difference(nowTime);
            int days = difference.inDays;
            if (days > 7) {
              // 删除超过7天的文件
              jdLog('离现在差距$days天 删除了-------->');
              FileTool.deleteFile(element);
            }
          }
        } catch (onError) {
          jdLog('转换后的onError--------> $onError');
        }
      });
    });
  }

  String formatFullInfo(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  String formatDateTime(DateTime dateTime,
      [String format = 'yyyy-MM-dd']) {
    return DateFormat(format).format(dateTime);
  }


  DateTime? parse(String? dateStr, [String format = 'yyyy-MM-dd']) {
    if (dateStr?.isNotEmpty != true) return null;
    return DateFormat(format).parse(dateStr!);
  }

}
