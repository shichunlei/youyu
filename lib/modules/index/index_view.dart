import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/theme.dart';
import 'index_logic.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final logic = Get.find<IndexLogic>();

  @override
  Widget build(BuildContext context) {
    ///预加载图片
    for (var element in logic.tabItems) {
      AssetImage normalImg = AssetImage(element.img ?? "");
      AssetImage activeImage = AssetImage(element.selImg ?? "");
      precacheImage(normalImg, context);
      precacheImage(activeImage, context);
    }

    ///加载试图
    return WillPopScope(
        onWillPop: () => logic.exitVerify(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color(0xFF000000),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: logic.pageController,
              children: logic.pages,
            ),
            bottomNavigationBar: GetBuilder<IndexLogic>(
              id: IndexLogic.tabId,
              builder: (s) {
                return BottomNavigationBar(
                  onTap: (index) {
                    logic.selectedTabBarIndex(index);
                  },
                  elevation: 1,
                  backgroundColor: const Color(0xFFFFFFFF),
                  type: BottomNavigationBarType.fixed,
                  //样式
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  //选中颜色
                  selectedItemColor: AppTheme.colorTextPrimary,
                  unselectedItemColor: AppTheme.colorTextPrimary,
                  items: logic.getBarItem(),
                  useLegacyColorScheme: false,
                  enableFeedback: false,
                  currentIndex: logic.currentIndex,
                );
              },
            )));
  }
}
