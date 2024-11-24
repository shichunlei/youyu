import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_category_type.dart';
import '../model/app_custom_emoji_item.dart';

class AppEmojiGifData {
  static AppEmojiGifData? _instance;

  factory AppEmojiGifData() => _instance ??= AppEmojiGifData._();

  List<AppCustomEmojiItem> gifDataList = [];

  AppEmojiGifData._() {
    for (int i = 1; i < 18; i++) {
      if (i == 1) {
        gifDataList.add(_createSpecialEmojiByGif("$i-gif"));
      } else {
        gifDataList.add(_createNormalEmojiByGif("$i-gif"));
      }
    }
  }

  //创建一个自定义特殊的Gif
  _createSpecialEmojiByGif(name) {
    List<String> gifs = [];
    for (int i = 0; i < 3; i++) {
      gifs.add("$name-${(i + 1)}");
    }
    return AppCustomEmojiItem(name, "png",
        isShowEnd: true, isRandom: true, emojis: gifs);
  }

  //创建一个自定义普通的Gif
  _createNormalEmojiByGif(name) {
    return AppCustomEmojiItem(name, "gif");
  }
}
