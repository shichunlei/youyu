import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

class TopBgLogin extends StatelessWidget {
  const TopBgLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppLocalImage(
        path: AppResource().loginTopBg,
        width: double.infinity,
      ),
    );
  }
}

class TopBgCommon extends StatelessWidget {
  const TopBgCommon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppLocalImage(
        path: AppResource().commonTopBg,
        width: double.infinity,
      ),
    );
  }
}

class TopBgMe extends StatelessWidget {
  const TopBgMe({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppLocalImage(
        path: AppResource().meTopBg,
        width: double.infinity,
      ),
    );
  }
}
