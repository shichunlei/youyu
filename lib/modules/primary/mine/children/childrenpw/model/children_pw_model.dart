enum ChildrenPwType {
  open, //开启 2步
  change, //修改 3步
  close //关闭 1步
}

enum ChildrenPwStep {
  step1,
  step2,
  step3,
}

class ChildrenPwModel {
  ChildrenPwModel(
      {required this.pwType, required this.pwStep, required this.stepPw});
  //设置类型
  final ChildrenPwType pwType;
  //设置步骤
  final ChildrenPwStep pwStep;
  //步骤的密码组,要保持相等
  final List<String> stepPw;
}
