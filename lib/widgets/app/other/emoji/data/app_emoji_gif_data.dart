import '../model/app_custom_emoji_item.dart';

class AppEmojiGifData {
  static AppEmojiGifData? _instance;

  factory AppEmojiGifData() => _instance ??= AppEmojiGifData._();

  List<AppCustomEmojiItem> gifDataList = [];

  AppEmojiGifData._() {
    for (int i = 0; i < 18; i++) {
      if (i == 0) {
        gifDataList.add(_createSpecialEmojiByGifFirst("$i-gif"));
      } else if (i == 1) {
        gifDataList.add(_createSpecialEmojiByGif("$i-gif"));
      } else {
        gifDataList.add(_createNormalEmojiByGif("$i-gif"));
      }
    }
  }

  _createSpecialEmojiByGifFirst(name) {
    List<String> gifs = [];
    for (int i = 0; i < 6; i++) {
      gifs.add("$name-${(i + 1)}");
    }
    return AppCustomEmojiItem(name, "png",
        isShowEnd: true, isRandom: true, emojis: gifs);
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
