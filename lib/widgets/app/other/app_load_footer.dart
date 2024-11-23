import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
///底部加载更多
class AppLoadMoreFooter {
  static Widget getFooter({required bool isEmptyData, double height = 55.0}) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (isEmptyData) {
          return Container();
        } else {
          if (mode == LoadStatus.idle) {
            body = Container();
          } else if (mode == LoadStatus.loading) {
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(),
                Container(
                  width: 10,
                ),
                const Text(
                  "加载中...",
                  style: TextStyle(
                      color: Color(0x33FFFFFF), fontSize: 12),
                ),
              ],
            );
          } else if (mode == LoadStatus.failed) {
            body = const Text(
              "加载失败，请点击重试",
              style: TextStyle(
                  color: Color(0x33FFFFFF), fontSize: 12),
            );
          } else if (mode == LoadStatus.noMore) {
            body = const Text(
              "沒有更多了",
              style: TextStyle(
                  color: Color(0x33FFFFFF), fontSize: 12),
            );
          } else {
            body = const Text(
              "上拉加载...",
              style: TextStyle(
                  color: Color(0x33FFFFFF), fontSize: 12),
            );
          }
        }
        return SizedBox(
          height: height,
          child: Center(child: body),
        );
      },
    );
  }
}
