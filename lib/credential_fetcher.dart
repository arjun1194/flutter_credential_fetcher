import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CredentialFetcher extends StatefulWidget {
  ///site whos whose cookies you want to aquire
  final String url;

  /// a callback function which runs when we have aquired the cookie successfully
  final Function(String) callback;

  ///if you wan to show a custom Widget while the webpage loads
  ///otherwise just use a empty container
  final Widget loader;

  const CredentialFetcher({
    Key key,
    @required this.url,
    @required this.callback,
    @required this.loader,
  }) : super(key: key);

  @override
  _CredentialFetcherState createState() => _CredentialFetcherState();
}

class _CredentialFetcherState extends State<CredentialFetcher> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  //state
  String initCookies = "empty";
  Timer timer;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: <Widget>[
        widget.loader,
        WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          onPageStarted: (String url) {
            index = 0;
          },
          onPageFinished: (String url) {
            setState(() {
              index = 1;
            });
            _controller.future.then((controller) {
              timer = new Timer.periodic(Duration(seconds: 3), (Timer t) async {
                getCookies(controller, context).then((cookieString) {
                  print("debug: " + cookieString);
                  if (initCookies == "empty") {
                    initCookies = cookieString;
                  }

                  //rule that defines when we have acquired the cookies successfully
                  if (stopCondition(cookieString)) {
                    widget.callback(cookieString);
                    timer.cancel();
                  }
                });
              });
            }).catchError((err) {
              return err;
            });
          },
          gestureNavigationEnabled: true,
        ),
      ],
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<String> getCookies(
      WebViewController controller, BuildContext context) async {
    return await controller.evaluateJavascript('document.cookie');
  }


  bool stopCondition(String cookieString){
    // i know this is bad code but
    //for instagram we have 11 cookies so...
    //life is hard code likhne me fat jaati hai gaand
    return (cookieString.split(";").length==11);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
