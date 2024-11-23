import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/list/widget/base/im_msg_base_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class IMMsgTextWidget extends IMMsgBaseWidget {
  const IMMsgTextWidget(
      {super.key, required super.message, required super.index, required super.logic});

  @override
  _IMMsgTextWidgetState<IMMsgTextWidget> createState() =>
      _IMMsgTextWidgetState();
}

class _IMMsgTextWidgetState<T extends IMMsgTextWidget>
    extends IMMsgBaseWidgetState<IMMsgTextWidget> {
  @override
  senderContent() {
    return AppRow(
      constraints: BoxConstraints(
        minHeight: 32.h,
        maxWidth: IMMsgBaseWidget.itemMaxWidth,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      gradient: AppTheme().btnGradient,
      topLeftRadius: 6.w,
      topRightRadius: 6.w,
      bottomLeftRadius: 6.w,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Text(
          widget.message.textElem?.text ?? "",
          maxLines: 10000,
          style: AppTheme().textStyle(
              fontSize: 14.sp,
              color: AppTheme.colorTextWhite,
              fontWeight: FontWeight.w500),
        ))
      ],
    );
  }

  @override
  receiveContent() {
    return AppRow(
      constraints: BoxConstraints(
        minHeight: 32.h,
        maxWidth: IMMsgBaseWidget.itemMaxWidth,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      color: AppTheme.colorTextWhite,
      topLeftRadius: 6.w,
      topRightRadius: 6.w,
      bottomRightRadius: 6.w,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Text(
          widget.message.textElem?.text ?? "",
          maxLines: 10000,
          style: AppTheme().textStyle(
              fontSize: 14.sp,
              color: AppTheme.colorTextPrimary,
              fontWeight: FontWeight.w500),
        ))
      ],
    );
  }
}
