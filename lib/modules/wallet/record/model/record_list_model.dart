import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RecordListModel {

  //标题
  String? title;

  //副标题
  String? exTitle;

  //时间
  String? time;

  //右边的值
  String? rightValue;

  //右边的副值
  String? rightSubValue;

  //提现状态 (0 已到账 1 已驳回 2 待审核)
  int withDrawState = 0;

  //是否收入
  bool isIn = false;


}
