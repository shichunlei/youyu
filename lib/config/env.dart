class FlagValue {
  //环境value
  static const String debug = "debug";
  static const String release = "release";
}

///环境配置
class EvnConfig {
  //环境key
  static const String _envKey = "ENV_FLAG";
  //app的环境
  static const appFlag =
      String.fromEnvironment(_envKey, defaultValue: FlagValue.release);

  EvnConfig._();
}
