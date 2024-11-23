import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/search/search_top_bar.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/services/search_service.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_wrap_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_index_logic.dart';

class SearchIndexPage extends StatelessWidget {
  SearchIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<SearchIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SearchIndexLogic>(
      resizeToAvoidBottomInset: false,
      appBar: SearchTopBar(
        controller: logic.searchController,
        onSubmitted: (value) {
          logic.search(value);
        },
      ),
      childBuilder: (s) {
        return Container(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: ListView(
            children: [
              SizedBox(
                height: 48.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //两端对齐
                  children: [
                    Text("搜索历史",
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextDark)),
                    InkWell(
                      onTap: () {
                        logic.clearHistory();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 48.w,
                        height: 48.h,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AppLocalImage(
                            path: AppResource().del,
                            width: 16.w,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              AppWrapList(
                list: SearchService().keyWords,
                onClickItem: (int index, String value) {
                  logic.search(value);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
