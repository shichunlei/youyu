import 'package:youyu/services/http/http_manager.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as WebViewA;
import 'web_logic.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> with AutomaticKeepAliveClientMixin {
  final logic = Get.find<WebLogic>();

  @override
  void initState() {
    super.initState();
    logic.webParam = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AppPage<WebLogic>(
        appBar: AppTopBar(
          title: logic.webParam?.title ?? "",
        ),
        child: WebViewA.InAppWebView(
          initialOptions: WebViewA.InAppWebViewGroupOptions(
            crossPlatform: WebViewA.InAppWebViewOptions(
                transparentBackground: true,
                userAgent: HttpManager().getDefaultUserAgent(),
                javaScriptEnabled: true,
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true,
                javaScriptCanOpenWindowsAutomatically: true),
            android: WebViewA.AndroidInAppWebViewOptions(
                hardwareAcceleration: false, useHybridComposition: true),
          ),
          androidOnPermissionRequest: (controller, origin, resources) async {
            return WebViewA.PermissionRequestResponse(
                resources: resources,
                action: WebViewA.PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (WebViewA.InAppWebViewController controller,
              WebViewA.NavigationAction navigationAction) async {
            String url = navigationAction.request.url.toString();
            if (url.contains((logic.webParam?.url ?? ""))) {
              return WebViewA.NavigationActionPolicy.ALLOW;
            }
            return WebViewA.NavigationActionPolicy.CANCEL;
          },
          onTitleChanged: (controller, String? title) {
            setState(() {
              if ((logic.webParam?.title ?? "").isEmpty) {
                logic.webParam?.title = title ?? "";
              }
            });
          },
          //老版本：initialUrl    新版本：initialUrlRequest
          initialUrlRequest:
              WebViewA.URLRequest(url: Uri.parse(logic.webParam?.url ?? "")),
          onWebViewCreated: (controller) async {
            logic.controller = controller;
          },
          onProgressChanged: (controller, progress) {
            if (progress / 100 > 0.990) {
              logic.setIsLoading = false;
            }
          },
          onLoadStart: (WebViewA.InAppWebViewController controller, Uri? url) {
            logic.setIsLoading = true;
          },
          onLoadError: (WebViewA.InAppWebViewController controller, Uri? url,
              int code, String message) {
            logic.setIsLoading = false;
          },
          onLoadHttpError: (WebViewA.InAppWebViewController controller,
              Uri? url, int statusCode, String description) {},
          onReceivedServerTrustAuthRequest: (controller, challeang) async {
            return WebViewA.ServerTrustAuthResponse(
                action: WebViewA.ServerTrustAuthResponseAction.PROCEED);
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
