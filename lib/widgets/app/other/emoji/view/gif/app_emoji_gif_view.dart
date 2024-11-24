import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tabs.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_category_type.dart';
import 'package:youyu/widgets/app/other/emoji/view/app_emoji_sub_view.dart';
import '../../model/app_custom_emoji_category.dart';
import '../../model/app_custom_emoji_item.dart';

class AppEmojiGifView with AppEmojiSubView {
  AppEmojiGifView({required this.config, required this.onClick});

  final Config config;
  final Function(AppCustomEmojiItem item) onClick;

  AppCustomEmojiCategory? customCategory;

  ///AppCustomEmojiCategory
  @override
  Tab createTab(category) {
    return Tab(
      icon: Icon(
        _getIconForCategory(category.categoryType),
      ),
    );
  }

  //AppCustomEmojiCategory
  Widget createPageView(category) {
    customCategory = category;
    var space = 25.w;
    return GridView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: space,
          //垂直子Widget之间间距
          mainAxisSpacing: 10.h,
          //一行的Widget数量
          crossAxisCount: 4,
          //子Widget宽高比例
          childAspectRatio: 100 / 100,
        ),
        itemCount: customCategory?.emojiList.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          AppCustomEmojiItem? item = customCategory?.emojiList[index];
          return InkWell(
            child: AppLocalImage(
              width: (ScreenUtils.screenWidth - 10 * 2.w + space * 3) / 4,
              path: item?.name ?? "",
            ),
            onTap: () {
              if (item != null) {
                onClick(item);
              }
            },
          );
        });
  }

  IconData _getIconForCategory(AppCustomEmojiType type) {
    switch (type) {
      case AppCustomEmojiType.GIF:
        return Icons.pets;
      default:
        throw Exception('Unsupported Category');
    }
  }
}
