import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class CheweiList extends StatefulWidget {
  String link;
  CheweiList(this.link);
  @override
  State<StatefulWidget> createState() {
    return  _CheweiList(link);
  }
}

class _CheweiList extends State<CheweiList> {
 String link; 
  VideoPlayerController videoPlayerController;
  ChewieController _chewieController;
  Future _future;
  _CheweiList(this.link);
 Future  initVideoPlayer() async{
   print('inititalizing in video player');
   await videoPlayerController.initialize();
   setState(() {
     print('aspect ratio ${videoPlayerController.value.aspectRatio.toString()}');
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        //aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: false,
        errorBuilder: (context, errorMessage) {
          return Center(child: Text(errorMessage));
        });

   });
  }
  @override
  void initState() {
    super.initState();
    print('in init');
    videoPlayerController = VideoPlayerController.network(link);
    _future = initVideoPlayer();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
              child: FutureBuilder(future: _future, builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Center(child:videoPlayerController.value.initialized?
                AspectRatio(aspectRatio: videoPlayerController.value.aspectRatio,child: Chewie(controller: _chewieController,),)
                : CircularProgressIndicator());
              },),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
