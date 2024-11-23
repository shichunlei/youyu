import 'package:youyu/utils/screen_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/app_loading.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'big_image_logic.dart';

class BigImagePage extends StatefulWidget {
  const BigImagePage({Key? key}) : super(key: key);

  @override
  State<BigImagePage> createState() => _BigImagePageState();
}

class _BigImagePageState extends State<BigImagePage> {
  final logic = Get.find<BigImageLogic>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PhotoViewGallery.builder(
                // 滑动到边界的交互 默认Android效果
                scrollPhysics: const BouncingScrollPhysics(),
                // 滑动方向 默认水平
                scrollDirection: Axis.horizontal,
                //是否逆转滑动的阅读顺序方向 默认false,true水平的话，图片从右向左滑动
                reverse: false,
                // 图片构造器
                builder: _buildItem,
                // 图片数量
                itemCount: logic.imageList.length,
                // 图片加载过程中显示的组件 可以显示加载进度
                loadingBuilder: (context, e) {
                  return const AppLoading(hasNavBar: false);
                },
                // 背景样式自定义
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                scaleStateChangedCallback: (photoViewScaleState) {
                  // 用户双击图片放大缩小时的回调
                },
                wantKeepAlive: false,
                //是否支持手势旋转图片
                enableRotation: true,
                //定义图片默认缩放基础的大小,默认全屏 MediaQuery.of(context).size
                customSize: MediaQuery.of(context).size,
                //是否允许隐式滚动 提供视障人士用的一个字段 默认false
                allowImplicitScrolling: true,
                pageController: logic.pageController,
                // 切换图片控制器
                onPageChanged: (index) {
                  // 图片切换回调
                  setState(() {
                    logic.curIndex = index;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "${logic.curIndex + 1}/${logic.imageList.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = logic.imageList[index];
    return PhotoViewGalleryPageOptions(
        // 图片加载器 支持本地、网络
        imageProvider: CachedNetworkImageProvider(item),
        // 初始化大小 全部展示
        initialScale: PhotoViewComputedScale.contained,
        // 最小展示 缩放最小值
        minScale: PhotoViewComputedScale.contained,
        // 最大展示 缩放最大值
        maxScale: PhotoViewComputedScale.covered * 4,
        // hero动画设置
        heroAttributes:
           logic.curIndex == index? PhotoViewHeroAttributes(tag: "${logic.itemTag}-$index"):null,
        onTapUp: (BuildContext context, TapUpDetails details,
            PhotoViewControllerValue controllerValue) {
          Get.back();
        });
  }
}
