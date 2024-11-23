import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:youyu/utils/orientation_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_keyboard_dismiss.dart';
import 'package:youyu/config/config.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/controllers/float_controller.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_system_style.dart';
import 'package:youyu/widgets/page_life_state.dart';
import 'router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    //设置竖屏
    OrientationUtils.setPortrait(),
    //设置顶部透明
    Future(() => ScreenUtils.setTopTransparent()),
    Future(() => FlutterDownloader.initialize(debug: true, ignoreSsl: true))
  ]);
  HttpOverrides.global = GlobalHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //initial binding
  late Bindings bindings;

  @override
  void initState() {
    super.initState();
    bindings = InitialBinding();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      getPages: AppRouter().routes(),
      themeMode: ThemeMode.light,
      initialBinding: bindings,
      initialRoute: AppRouter.initialRoutePath,
      navigatorObservers: [PageLifeState.routeObserver],
      defaultTransition: AppRouter.defaultTransition,
      transitionDuration: AppRouter.defaultTransitionDuration,
      locale: const Locale("zh", "CN"),
      fallbackLocale: const Locale("zh", "CN"),
      builder: (BuildContext context, Widget? child) {
        ScreenUtils.init(context);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: FlutterEasyLoading(
            child: AppSystemStyle(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: AppTheme.colorNavBar,
                statusBarIconBrightness: Brightness.light,
              ),
              child: AppKeyboardDismiss(
                child: FloatController.to.liveFloat(child: child!),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    //控制器
    Get.put<AppController>(AppController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<FloatController>(FloatController(), permanent: true);
    Get.put<GiftController>(GiftController(), permanent: true);
    Get.put<DynamicController>(DynamicController(), permanent: true);
    Get.put<ConversationController>(ConversationController(), permanent: true);
  }
}

class GlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
