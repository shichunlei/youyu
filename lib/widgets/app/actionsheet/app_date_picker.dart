import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart';

class AppDataPicker {
  ///日期选择器
  static void showDatePiker(BuildContext? context,
      {DateTime? minTime,
      DateTime? maxTime,
      Function(DateTime date)? onConfirm,
      Function(DateTime date)? onChanged}) {
    if (context == null) return;
    picker.DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: minTime ?? DateTime(1900, 3, 5),
        maxTime: maxTime ?? DateTime(2099, 6, 7),
        theme: picker.DatePickerTheme(
            backgroundColor: const Color(0xFFFFFFFF),
            doneStyle: AppTheme().textStyle(fontSize: 15, color: AppTheme.colorMain),
            cancelStyle: AppTheme().textStyle(
                fontSize: 15, color: const Color(0xFFD8D8D8)),
            itemStyle: AppTheme().textStyle(
                fontSize: 15,
                color: AppTheme.colorTextPrimary)), onChanged: (date) {
      if (onChanged != null) {
        onChanged(date);
      }
    }, onConfirm: (date) {
      if (onConfirm != null) {
        onConfirm(date);
      }
    }, locale: picker.LocaleType.zh);
  }

  static void showDataPicker2(context,
      {DateMode? mode, DateCallback? onConfirm}) {
    Pickers.showDatePicker(context,
        pickerStyle: PickerStyle(
            backgroundColor: AppTheme.colorDarkBg,
            textColor: AppTheme.colorTextWhite,
            cancelButton: AppContainer(
              width: 64.w,
              child: Center(
                child: Text(
                  "取消",
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextWhite),
                ),
              ),
            ),
            commitButton: AppContainer(
              width: 64.w,
              child: Center(
                child: Text(
                  "确定",
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorMain),
                ),
              ),
            ),
            headDecoration: BoxDecoration(
                color: AppTheme.colorDarkBg,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.w),
                    topLeft: Radius.circular(12.w)))),
        mode: mode ?? DateMode.YM,
        onConfirm: onConfirm);
  }
}
