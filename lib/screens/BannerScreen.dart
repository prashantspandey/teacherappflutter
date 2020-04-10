import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class BannerScreen extends StatefulWidget {
  TeacherUser user = TeacherUser();
  BannerScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _BannerScreen();
  }
}

class _BannerScreen extends State<BannerScreen> {
  bool uploadingProgress;
  var _image;
static const aws_platform = const MethodChannel('s3integration');
  static const uploadStream = const EventChannel('uploadEvents');
  double progressUp = 0;
  var _uploadInfo;


  uploadedTotalProgress(progressUpload){
    print('progress Upload ${progressUpload.toString()}');
      setState(() {
        progressUp = progressUpload;
      });
  }




  uploadImageS3(imagePath) async {
    setState(() {
      uploadingProgress = false;
    });
    print(imagePath.path.toString());
    String baseBucketUrl = 'https://instituteimages.s3.amazonaws.com/';

    //  String uploadedImageUrl = await AmazonS3Cognito.uploadImage(
    //  imagePath.path,
    //  'instituteimages',
    // 'us-east-1:c5dd200c-3cfc-44da-a1e1-7a5fc1f4a6e8',
    // );
    var timenow = DateTime.now().microsecond.toString();
    String path = imagePath.path;
    String fileName = imagePath.path.toString().split('/').last.toString();
     try{
      print('uplaod in res');
      //showLoadingDialog(context);
      var res = await aws_platform.invokeMethod('uploadFiles',{'path':path,'fileName':fileName});
      if(_uploadInfo == null){
        _uploadInfo = uploadStream.receiveBroadcastStream().listen(uploadedTotalProgress);
      }

      print('res s3 upload ${res.toString()}');
    if(res['status']=='Success'){
      String finalUrl = res['url'];
      print('final url ${res["url"].toString()}');
    var response = uploadBanner(widget.user.key, finalUrl);
  Fluttertoast.showToast(msg: 'Banner uploaded');
    print('total response ${response.toString()}');
    //Navigator.pop(context);
    return finalUrl;
    }
    else{
      Fluttertoast.showToast(msg: 'Upload failed. Please try again.');
    }
    }
    on PlatformException catch(e){

    }
    setState(() {
      uploadingProgress = true;
    });

    Navigator.pop(context);
  }

  showConfirmBanner(context,bannerId) async{
    return showDialog(context: context,barrierDismissible: true,builder: (context){
      return AlertDialog(content: Container(height:100,child: Column(children: <Widget>[
        Text('Are you sure you want to delete this banner?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Delete',style: TextStyle(color: Colors.white)), onPressed: () async{
            var response = await postDeleteBanner(widget.user.key, bannerId);
            Fluttertoast.showToast(msg: response['message']);
            Navigator.pop(context);
          },),
          RaisedButton(color: Colors.orange,child: Text('Cancel'), onPressed: () {
            Navigator.pop(context);
          },)
        ],)
      ],),),);
    });
  }
 void selectImageCall() async {
    await getImage();
    uploadImageS3(_image);
  }
   getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banners"),
        backgroundColor: Color(0xFFFF4700).withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 20),
              child: Text('Current Banners', style: TextStyle(fontSize: 30)),
            ),
            FutureBuilder(
              future: getAllBanners(widget.user.key),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  var banners = snapshot.data['banners'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width - 50,
                      child: ListView.builder(
                        itemCount: banners.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                      showConfirmBanner(context,banners[index]['id']).then((_)=>setState((){}));
                                      },
                                      child: CachedNetworkImage(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        imageUrl: banners[index]['link'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                                Text('Banner ${index + 1}')
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Spacer(),
                        Column(
                          
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(value: progressUp/100,backgroundColor: Colors.black,valueColor: AlwaysStoppedAnimation<Color> (Colors.orange),),
                            ),
                        Text('Uploaded:'+progressUp.toStringAsFixed(2)+' %'),
                          ],
                        ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Color(0xFFFF4700).withOpacity(0.95),
                  child: Text(
                    'Add Banner',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    selectImageCall();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
