import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

import '../wheel_game_view_logic.dart';

class WheelGameNavWidget extends StatelessWidget {
  const WheelGameNavWidget(
      {super.key, required this.viewType, required this.onTap});

  final WheelGameViewType viewType;
  final Function(WheelGameViewType viewType) onTap;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      alignment: Alignment.center,
      width: double.infinity,
      height: 36.w,
      children: [
        AppLocalImage(
          path: viewType == WheelGameViewType.primary
              ? AppResource().gameWheelTab1
              : AppResource().gameWheelTab2,
          width: 190.w,
          height: double.infinity,
        ),
        AppRow(
          width: 190.w,
          height: double.infinity,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: AppContainer(
              height: double.infinity,
              onTap: () {
                onTap(WheelGameViewType.primary);
              },
            )),
            Expanded(
                child: AppContainer(
              height: double.infinity,
              onTap: () {
                onTap(WheelGameViewType.advanced);
              },
            )),
          ],
        )
      ],
    );
  }
}
