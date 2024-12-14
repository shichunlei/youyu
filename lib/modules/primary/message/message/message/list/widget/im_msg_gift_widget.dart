import 'dart:convert';

import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/services/im/model/ext/im_gift_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'base/im_msg_base_widget.dart';

///礼物item
class IMMsgGiftWidget extends IMMsgBaseWidget {
  const IMMsgGiftWidget(
      {super.key, required super.message, required super.index, required super.logic});

  @override
  _IMMsgGiftWidgetState<IMMsgGiftWidget> createState() =>
      _IMMsgGiftWidgetState();
}

class _IMMsgGiftWidgetState<T extends IMMsgGiftWidget>
    extends IMMsgBaseWidgetState<IMMsgGiftWidget> {
  IMGiftModel? giftModel;

  @override
  void initState() {
    super.initState();
    giftModel = IMCustomMessageModel<IMGiftModel>.fromJson(
            IMMsgType.getTypeByType(widget.message.customElem?.desc ?? ""),
            jsonDecode(widget.message.customElem!.data!))
        .data;
  }

  @override
  senderContent() {
    String msgText =
        '您送出了\n${giftModel?.gift?.name ?? ""} ${giftModel?.gift?.unitPrice}*${giftModel?.gift?.count ?? 0}';
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        AppRow(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Text(
              msgText,
              maxLines: 10000,
              style: AppTheme().textStyle(
                  fontSize: 14.sp,
                  color: AppTheme.colorTextWhite,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(
              width: 8.w,
            ),
            AppNetImage(
              imageUrl: giftModel?.gift?.image ?? "",
              width: 35.w,
              height: 35.w,
              defaultWidget: const SizedBox.shrink(),
            )
          ],
        ),
        // SizedBox(
        //   height: 8.h,
        // ),
        // Text(
        //   '礼物总计：$total',
        //   maxLines: 10000,
        //   style: AppTheme().textStyle(
        //       fontSize: 14.sp,
        //       color: AppTheme.colorTextWhite,
        //       fontWeight: FontWeight.w500),
        // )
      ],
    );
  }

  @override
  receiveContent() {
    String msgText =
        '您收到了\n${giftModel?.gift?.name ?? ""} ${giftModel?.gift?.unitPrice}*${giftModel?.gift?.count ?? 0}';
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      constraints: BoxConstraints(
        minHeight: 32.h,
        minWidth: 150.w,
        maxWidth: IMMsgBaseWidget.itemMaxWidth,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      color: AppTheme.colorTextWhite,
      topLeftRadius: 6.w,
      topRightRadius: 6.w,
      bottomRightRadius: 6.w,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppRow(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Text(
              msgText,
              maxLines: 10000,
              style: AppTheme().textStyle(
                  fontSize: 14.sp,
                  color: AppTheme.colorTextPrimary,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(
              width: 8.w,
            ),
            AppNetImage(
              imageUrl: giftModel?.gift?.image ?? "",
              width: 35.w,
              height: 35.w,
              defaultWidget: const SizedBox.shrink(),
            )
          ],
        ),
        // SizedBox(
        //   height: 8.h,
        // ),
        // Text(
        //   '礼物总计：$total',
        //   maxLines: 10000,
        //   style: AppTheme().textStyle(
        //       fontSize: 14.sp,
        //       color: AppTheme.colorTextPrimary,
        //       fontWeight: FontWeight.w500),
        // )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
