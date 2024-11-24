
import 'app_custom_emoji_category_type.dart';
import 'app_custom_emoji_item.dart';

class AppCustomEmojiCategory {
  /// Constructor
  const AppCustomEmojiCategory(this.categoryType, this.emojiList);

  /// Custom Category instance
  final AppCustomEmojiType categoryType;

  ///List of Custom emoji of this category
  final List<AppCustomEmojiItem?> emojiList;
}
