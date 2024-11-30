import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/game/wheel/index/wheel_game_view_view.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'measurement_logic.dart';
import 'package:get/get.dart';

class MeasurementPage extends StatelessWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPage<MeasurementLogic>(
      appBar: const AppTopBar(
        title: "test",
      ),
      child: ListView(
        children: [
          // testItem("转盘", () {
          //   Get.bottomSheet(
          //     WheelGameViewPage(),
          //     isScrollControlled: true,
          //   );
          // }),
        ],
      ),
    );
  }

  Widget testItem(String title, Function onTap) {
    return SizedBox(
      height: 44,
      child: Column(
        children: [
          InkWell(
            child: Container(
              alignment: Alignment.center,
              height: 43,
              child: Text(
                title,
                style: AppTheme().textStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              onTap();
            },
          ),
          Container(
            height: 1,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
