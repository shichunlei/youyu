import 'dart:ui';

class ColorUtils {
  static Color? string2Color(String? colorString) {
    if (colorString != null && colorString.isNotEmpty == true) {
      int? value = 0x00000000;
      if (colorString.isNotEmpty) {
        if (colorString[0] == "#") {
          colorString = colorString.substring(1);
        }
        value = int.tryParse(colorString, radix: 16);
        if (value != null && value < 0xff000000) {
          value += 0xff000000;
        }
      }
      if (value != null) {
        return Color(value);
      } else {
        return null;
      }
    }
    return null;
  }
}
