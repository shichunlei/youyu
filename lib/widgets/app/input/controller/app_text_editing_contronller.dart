import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'entity/ait_span_entity.dart';

class AppTextEditingController extends TextEditingController {
  List<SpanEntity> spanList = [];

  String get rulerText {
    return spanList
        .map((e) => e.text.startsWith('\$') ? '\\${e.text}' : e.text)
        .toSet()
        .toList()
        .join('|');
  }

  Map<String, Color> get spanColor {
    Map<String, Color> color = {};
    for (var element in spanList) {
      if (!color.containsKey(element.text)) {
        color[element.text] = element.color ?? Colors.red;
      }
    }
    return color;
  }

  int textSize = 0; // 保存上一次文本 方便做比较
  SpanEntity? insertSpanCache;
  String _lastText = ''; // 存储上一次的文本内容
  bool isOwnDel = false; // 对于我们自己删除导致的文本变化 拦截addListener，避免多次执行

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    RegExp regex = RegExp(rulerText); // RegExp(r'@牛逼|#大事件');
    Iterable<RegExpMatch> matches = regex.allMatches(value.text);
    int lastEnd = 0;
    List<TextSpan> spans = [];
    for (RegExpMatch match in matches) {
      final matchText = match.group(0);
      // 前部分文本
      final preMatch = text.substring(lastEnd, match.start);
      if (preMatch.isNotEmpty) {
        spans.add(TextSpan(text: preMatch));
      }
      Color highLightColor = spanColor[matchText] ?? Colors.red;
      // 目标文本
      spans.add(
          TextSpan(text: matchText, style: TextStyle(color: highLightColor)));

      lastEnd = match.end;
    }
    // 目标后面的文本
    final tail = text.substring(lastEnd);
    if (tail.isNotEmpty) {
      spans.add(TextSpan(text: tail));
    }

    return TextSpan(style: style, children: spans);
  }

  void insertSpan(SpanEntity span) {
    insertSpanCache = span;
    // 获取当前光标位置
    int cursorPosition = selection.base.offset;
    int endPosition = cursorPosition + span.text.length;
    span.start = cursorPosition;
    span.end = endPosition;
    spanList.add(span);
    // print("cursorPosition:$cursorPosition,endPosition:$endPosition");
    // 将文本插入到光标位置
    String newText = text.substring(0, cursorPosition) +
        span.text +
        text.substring(cursorPosition);
    // 更新TextField的内容
    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: endPosition),
    );
    // 如果第一个文本就是一个文字块，比如span(0,6）
    // 此时光标移入0的位置，再次插入文字块span(0,4）
    // 就会变成 spanList=[span(0,6）,span(0,4）]，也就是文字块的起始位置冲突了
    // 也就是span(0,6）本来应该往后位移，但是两个位置冲突了，导致beforeTextChanged位移运行无法正常执行
  }

  // void isDeleteSpan() {
  //   SpanEntity? spanEntity =
  //       spanList.firstWhereOrNull((element) => element.end == selection.end);
  //   if (spanEntity != null) {
  //     spanList.removeWhere((element) => element.end == selection.end);
  //     deleteText(spanEntity.text.length);
  //     // print("spanList:${spanList.length}");
  //   } else {
  //     deleteText(1);
  //   }
  // }

  void onSelectionChanged() {
    SpanEntity? spanEntity =
        getRangeOfNearbySpan(selection.start, selection.end);
    // print("sel:${selection.start},${selection.end}");
    if (spanEntity != null) {
      if (selection.start == selection.end) {
        // 如果光标是在文字块中 则设置光标在文字块两侧 --保证光标无法插入文字块
        int position = spanEntity.getAnchorPosition(selection.start);
        if (position <= text.length) {
          TextSelection newSelection =
              TextSelection.fromPosition(TextPosition(offset: position));
          selection = newSelection; // 移动光标到新的位置
        }
        // print("spanEntity:${spanEntity.start},${spanEntity.end}");
      } else {
        // 如果选择范围，文字块保持全部选中
        if (selection.end < spanEntity.end) {
          setSelection(selection.start, spanEntity.end);
        }
        if (selection.start > spanEntity.start) {
          setSelection(spanEntity.start, selection.end);
        }
      }
    }

    // List<List<Object>> list=spanList.map((e) => [e.text,e.start,e.end]).toList();
    // print("光标位置：${selection.end},${jsonEncode(list)}");
  }

  SpanEntity? getRangeOfNearbySpan(int selStart, int selEnd) {
    return spanList
        .firstWhereOrNull((element) => element.isWrappedBy(selStart, selEnd));
  }

  void setSelection(int start, int end) {
    // 使用TextSelection对象设置选择范围
    selection = TextSelection(baseOffset: start, extentOffset: end);
  }

  void deleteText(int textLength) {
    if (text.isEmpty) return;
    isOwnDel = true;
    final TextEditingValue oldValue = value;
    final int start = oldValue.selection.baseOffset;
    final int end = oldValue.selection.extentOffset;

    if (start == end) {
      if (start == 0) return;
      final TextEditingValue newValue = TextEditingValue(
        text: oldValue.selection
                .textBefore(oldValue.text)
                .substring(0, start - textLength) +
            oldValue.selection.textAfter(oldValue.text),
        selection: TextSelection.collapsed(offset: start - textLength),
      );
      value = newValue;
    } else {
      // 这里处理选择文本的删除
      int count = end - start;
      final TextEditingValue newValue = TextEditingValue(
        text: oldValue.selection
                .textBefore(oldValue.text)
                .substring(0, end - count) +
            oldValue.selection.textAfter(oldValue.text),
        selection: TextSelection.collapsed(offset: end - count),
      );
      value = newValue;
    }
  }

  void beforeTextChanged() {
    int count = text.length - textSize;
    int end = selection.end;
    if (end < 0) {
      // 没有焦点的情况下直接返回，一般是event编辑的时候会出现
      textSize = text.length;
      return;
    }
    int start = end - count;
    List<SpanEntity> list = spanList;
    if (insertSpanCache != null) {
      // 过滤掉本次插入的文字块
      list = list.where((el) => el.id != insertSpanCache!.id).toList();
      insertSpanCache = null;
    }
    for (var element in list) {
      if (element.start >= start && count != 0) {
        element.setOffset(count);
      }
    }
    // print('count: $count, start: $start, end: $end');
    textSize = text.length;
  }

  void isDelText() {
    var currentText = text;
    final currentCursorPosition = selection.start;
    // 如果文本长度减少，则认为是删除操作
    if (currentText.length < _lastText.length) {
      final deletedTextLength = _lastText.length - currentText.length;
      // 反推删除前的光标位置
      final cursorPositionBeforeDelete =
          currentCursorPosition + deletedTextLength;
      if (deletedTextLength == 1) {
        var span = spanList.firstWhereOrNull(
            (element) => element.end == cursorPositionBeforeDelete);
        //1.是否删除文字块
        if (span != null) {
          var delLength = currentCursorPosition - span.start;
          //2.输入框的文字块删除
          deleteText(delLength);
          //3.spanList中文字快删除
          spanList.removeWhere(
              (element) => element.end == cursorPositionBeforeDelete);
          //4. 删除完成之后，赋值给currentText
          currentText = text;
        }
      } else {
        //[currentCursorPosition,cursorPositionBeforeDelete]
        spanList.removeWhere((element) =>
            element.start >= currentCursorPosition &&
            element.end <= cursorPositionBeforeDelete);
        currentText = text;
      }
    }
    // 更新最后的文本内容为当前内容
    _lastText = currentText;
  }

  String getUploadFormatText() {
    // 必须要排序，因为每次插入的位置都是不固定的，但是拼接数据的时候，必须要从最前面或者最后来拼接，因此需要做排序处理
    spanList.sort((a, b) => a.start.compareTo(b.start));

    int lastRangeTo = 0;
    StringBuffer buffer = StringBuffer();
    String newChar;

    for (SpanEntity range in spanList) {
      buffer.write(text.substring(lastRangeTo, range.start));
      newChar = range.formatText;
      buffer.write(newChar);
      lastRangeTo = range.end;
    }

    buffer.write(text.substring(lastRangeTo));
    return buffer.toString();
  }

  void parseIntoEditableText(String content) {
    RegExp regex = RegExp(r'\{\[(.*?),(\d+)(?:,(\d+))?\]\}');
    List<Match> matches = regex.allMatches(content).toList();

    List<SpanEntity> list = [];
    int lastRangeTo = 0;
    int lastChangeCount = 0; // 上一次变化的数量
    StringBuffer buffer = StringBuffer();
    for (Match match in matches) {
      String? target = match.group(0);
      String? name = match.group(1);

      int start = match.start;
      int end = match.end;
      buffer.write(content.substring(lastRangeTo, start));
      buffer.write(name); // 替换内容

      SpanEntity range = SpanEntity(name!, target!);
      range.start = start - lastChangeCount;
      range.end = (start + name.length) - lastChangeCount;

      if (name.startsWith("@")) range.color = Colors.cyan;
      if (name.startsWith("#")) range.color = Colors.orange;
      if (name.startsWith("\$")) range.color = Colors.lightBlue;
      list.add(range);
      // 注意，content的内容是不会变的
      // 智选@tip 车业务提供智能系统及部件解#event 决方案的独立新公司
      // @tip 的位置就是[3,7]，下一个比配到的词应该从7开始截取
      lastRangeTo = end;
      // 记住本次变量的长度,这里和原生有点区别 ,每比配到一個，是需要累加的
      // 由于每一个target- name的长度是不一样的，所以需要累加
      lastChangeCount += (target.length - name.length);
    }
    buffer.write(content.substring(lastRangeTo));
    spanList.addAll(list);
    text = buffer.toString();
    // Map<String, Object> map = {"content": buffer.toString(), "span_list": list};
    // return map;
  }
}
