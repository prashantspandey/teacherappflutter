import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class NoteWebView extends StatefulWidget{
  String url;
  NoteWebView(this.url);
  @override
  State<StatefulWidget> createState() {
    return _NoteWebView(url);
  }

}


class _NoteWebView extends State<NoteWebView>{
  String url;
  var _stackToView = 1;
  _NoteWebView(this.url);

  void _handleLoad(String value){
    setState(() {
      _stackToView = 0;
    });
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: IndexedStack(index: _stackToView,
   children: <Widget>[
     Column(
       children: <Widget>[
         Expanded(child: WebView(initialUrl: url.replaceAll("\"", ""), javascriptMode: JavascriptMode.unrestricted,debuggingEnabled: true,onPageFinished: _handleLoad,),),


       ],
     ),

         Container(color:Colors.black,child: Center(child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[

             Padding(
               padding: const EdgeInsets.all(8.0),
               child: CircularProgressIndicator(backgroundColor: Colors.white,),
             ),
             Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 20),)
           ],
         ),),),
   ], 
    ),);
  }

}