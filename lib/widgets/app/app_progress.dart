import 'package:flutter/material.dart';

///加载弹框
class ProgressDialog {
  static bool _isShowing = false;

  static void showProgressText(BuildContext? context, {String msg = ""}) {
    if (context == null) return;
    if (!_isShowing) {
      _isShowing = true;
      Navigator.push(
        context,
        _PopRoute(
          child: _Progress(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                //保证控件居中效果
                child: SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: Container(
                    decoration: const ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 4.0,
                          valueColor: AlwaysStoppedAnimation(Colors.black38),
                        ),
                        if (msg.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 10, right: 10),
                            child: Text(
                              msg,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  ///隐藏
  static void hideProgress(BuildContext? context) {
    if (_isShowing && context != null) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }
}

///Widget
class _Progress extends StatelessWidget {
  final Widget child;

  const _Progress({
    Key? key,
    required this.child,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Center(
          child: child,
        ));
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  final Widget child;

  _PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
