import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/vip/model/vip_index_model.dart';
import 'package:youyu/modules/submod/vip/vip_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';

class VipPriceWidget extends StatelessWidget {
  const VipPriceWidget(
      {super.key,
      required this.list,
      required this.selModel,
      required this.onClickPrice,
      required this.isSVip});

  final VipPriceModel? selModel;
  final List<VipPriceModel> list;
  final bool isSVip;
  final Function(VipPriceModel model) onClickPrice;

  @override
  Widget build(BuildContext context) {
    double itemWidth =
        (ScreenUtils.screenWidth - 15 * 2.w - 12 * 2.w) / 3 - 0.5.w;
    return AppColumn(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      children: [
        SizedBox(
          width: double.infinity,
          height: 158.h,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                VipPriceModel model = list[index];
                return AppColumn(
                  onTap: () {
                    onClickPrice(model);
                  },
                  topLeftRadius: 11.w,
                  bottomLeftRadius: 11.w,
                  topRightRadius: 25.w,
                  bottomRightRadius: 11.w,
                  strokeWidth: 1.w,
                  strokeColor: VipLogic.borderColor(isSVip),
                  mainAxisAlignment: MainAxisAlignment.center,
                  width: itemWidth,
                  color: selModel == model ? const Color(0xFFFFE9D2) : null,
                  gradient: selModel == model
                      ? null
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(0x60000000),
                            Color(0x60D8D8D8),
                            Color(0x60000000)
                          ],
                        ),
                  height: 158.h,
                  children: [
                    Text(
                      model.title ?? "",
                      style: AppTheme().textStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: _titleColor(model)),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    RichText(
                        text: TextSpan(
                      text: "¥",
                      style: AppTheme().textStyle(
                          fontSize: 12.sp, color: _titleColor(model)),
                      children: <TextSpan>[
                        TextSpan(
                            style: AppTheme().textStyle(
                                fontSize: 16.sp, color: _titleColor(model)),
                            text: model.price ?? ""),
                      ],
                    )),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(model.oriPrice ?? "",
                        style: AppTheme().textStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14.sp,
                              color: _titleColor(model),
                            )),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(model.tip ?? "",
                        textAlign: TextAlign.center,
                        style: AppTheme().textStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF9E9E9E),
                            )),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 12.w,
                );
              },
              itemCount: list.length),
        ),
        AppColumn(
          width: double.infinity,
          crossAxisAlignment: CrossAxisAlignment.start,
          margin: EdgeInsets.only(top: 20.h),
          children: [
            Text(
              '支付说明',
              style: AppTheme().textStyle(
                  fontSize: 16.sp, color: AppTheme.colorTextWhite),
            ),
            const SizedBox(
              height: 13,
            ),
            Text(
              '1.到期自动续费，可随时取消',
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: const Color(0xFF9E9E9E)),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '2.未成年人不得在抹茶进行充值',
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: const Color(0xFF9E9E9E)),
            ),

          ],
        ),
        AppColorButton(
          margin: EdgeInsets.only(left: 3.w,right: 3.w,top: 25.h),
          height: 56.h,
          borderRadius: BorderRadius.all(Radius.circular(18.w)),
          borderColor: VipLogic.borderColor(isSVip),
          bgGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0x60000000),
              Color(0x60D8D8D8),
              Color(0x60000000)
            ],
          ),
          title: "立即开通",
          titleColor: VipLogic.textColor(isSVip),
        )
      ],
    );
  }

  _titleColor(model) {
    return selModel == model
        ? const Color(0xFFF48815)
        : AppTheme.colorTextWhite;
  }
}
