import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_category_type.dart';

import '../model/app_custom_emoji_item.dart';

class AppEmojiGifData {
  static String GIF_1 = "1-gif";

  static Map<String, AppCustomEmojiItem> gifData = {
    GIF_1: _createCustomEmojiByGif(GIF_1),
  };

  //创建一个自定义的Gif
  static _createCustomEmojiByGif(name) {
    List<String> gifs = [];
    for (int i = 0; i < 3; i++) {
      gifs.add(AppResource.getGif("$name-${(i + 1)}"));
    }
    return AppCustomEmojiItem(
        AppCustomEmojiType.GIF, AppResource.getGif(name, format: "png"), gifs);
  }
}
