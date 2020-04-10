import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class NativeVideoWebView extends StatefulWidget{
  String url;
  NativeVideoWebView(this.url);
  @override
  State<StatefulWidget> createState() {
    return _NativeVideoWebView(url);
  }

}


class _NativeVideoWebView extends State<NativeVideoWebView>{
  String url;
  _NativeVideoWebView(this.url);
  @override
  @override
  Widget build(BuildContext context) {
    print('web view ${url.toString()}');
    return  Scaffold(body: WebView(initialUrl: url.replaceAll("\"", ""), javascriptMode: JavascriptMode.unrestricted,debuggingEnabled: true,),);
  }

}