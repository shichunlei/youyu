/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-10-30 11:22:33
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-07 23:29:06
 * @FilePath: /youyu/lib/config/config.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'env.dart';

///app核心配置
///18792931682
// 18792931681
// 18792931683
// 18792931684
// 18792931685
// 18792931686
// 18792931687
// 18792931688
// 1
class AppConfig {
  //应用名称
  static const String appName = "友遇";

  // 请求地址
  static final String baseUrl = _getUrl('api');

  // ws地址
  static final String wsUrl = _getUrl('wss');

  // 根据构建模式返回不同的请求地址
  static String _getUrl(String path) {
    //更改debug快速切换不同的环境
    const String base = EvnConfig.appFlag == FlagValue.debug ? 'test.youyu.ac.cn' : 'www.youyu.ac.cn';
    final String protocol = path == 'wss' ? 'wss' : 'https';
    return '$protocol://$base/$path/';
  }

  //im AppId
  static const int imAppId = 1600058032;

  //阿里一键登录
  static const String aliKeyIos =
      '68DhW8rSRUVNHTxc6lQX/KlKTjhU5UCRbm0PDftm0cvQTCksVW5d0ccm2FYw6vNzRenqzO5lGXeVZRCsRPWm0nFPWqdM9PxXdSyUO4OKN/UV74oEBIFUuGxQ3aEX1PJWS+cgWYXPX5t8jVohSNz9Ou36cHlnZHHkuXk243I51dOVyt39sgsLvbIopw3yuXYTKkf1nPtsxcCU7uQv1/DR0q2N9i7/vLTCXwX/F0+t34BkJx5aAdGh9JIHJ89283/p';

  static const String aliKeyAndroid =
      '+/KU2J9Mv2EfridLxWLc+Gj+JiD3MMlPFfuNjrmfIC3okorQ+9tVWmmtvGzj7RVnYPFSuNrbwG+2kjlWM8E90UVXXgAV7pNeGWiq0McKRKMc2MpTWR0+se8xknz+lTS9zxoC/QpynxXESv9xWYGEuJgLQe3ErygLPUxLe/nrsg7U4x8CJAU3mNmobCw9gTpoaMNYMfrpXSJB21ykik1v+3y14l1UbASLCbx7RmSE03SXbl/ZsXObuJUqUJIojcyW/+owZ5lYO28+HyII5RUsmVNPmBqrtDpRjL6MUmHnWPE=';
}
