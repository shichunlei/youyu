import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_page.dart';

//默认页面配置
class AppDefaultConfig {
  const AppDefaultConfig({required this.title,
    required this.image,
    this.size,
    this.margin,
    this.isShowRepeat = true});

  final double? size;
  final String title;
  final String image;
  final EdgeInsetsGeometry? margin;
  final bool isShowRepeat;

  //默认配置
  static AppDefaultConfig defaultConfig(AppLoadType loadType,
      {String? msg, EdgeInsets? margin, double? size}) {
    if (loadType == AppLoadType.empty) {
      return AppDefaultConfig(
          title: msg ?? "暂无数据",
          image: AppResource().empty,
          margin: margin, size: size);
    } else {
      return AppDefaultConfig(
          title: msg ?? "加载失败",
          image: AppResource().empty,
          margin: margin, size: size);
    }
  }
}

///默认页面
class AppDefault extends StatelessWidget {
  const AppDefault({Key? key, required this.loadType, this.config, this.reload})
      : super(key: key);

  //类型
  final AppLoadType loadType;

  //配置
  final AppDefaultConfig? config;

  //点击重试
  final void Function()? reload;

  @override
  Widget build(BuildContext context) {
    AppDefaultConfig fConfig =
        config ?? AppDefaultConfig.defaultConfig(loadType);
    if (loadType == AppLoadType.empty) {
      return empty(fConfig);
    } else {
      return error(fConfig);
    }
  }

  //空白页
  Widget empty(AppDefaultConfig defaultConfig) {
    return LayoutBuilder(
      builder: (_, size) {
        return Container(
          alignment: Alignment.topCenter,
          padding: defaultConfig.margin ??
              EdgeInsets.only(top: size.maxHeight * 0.3),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: AssetImage(defaultConfig.image),
                  width: config?.size ?? 100.w,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  defaultConfig.title,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //失败页
  Widget error(AppDefaultConfig defaultConfig) {
    return LayoutBuilder(
      builder: (_, size) {
        return Container(
          alignment: Alignment.topCenter,
          padding: defaultConfig.margin ??
              EdgeInsets.only(top: size.maxHeight * 0.3),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: reload,
            child: Column(
              children: [
                Image(
                  image: AssetImage(defaultConfig.image),
                  width: config?.size ?? 117.w,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  defaultConfig.isShowRepeat
                      ? "${defaultConfig.title}，点击重试"
                      : defaultConfig.title,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
