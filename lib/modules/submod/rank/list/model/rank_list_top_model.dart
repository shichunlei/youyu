/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-10-13 20:45:39
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-04 23:40:34
 * @FilePath: /youyu/lib/modules/submod/rank/list/model/rank_list_top_model.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/submod/rank/list/model/cp_rank_list_model.dart';

class RankListTopModel {
  RankListTopModel({required this.list});

  final List<UserInfo> list;
}

class CpRankListTopModel {
  CpRankListTopModel({required this.list});
  final List<CpRankModel> list;
}
