import 'package:bodhiai_teacher_flutter/CardScrollwidget.dart';
import 'package:bodhiai_teacher_flutter/Myslide.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/images.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CommunicationScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/ContentScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/ManagementScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/MarketingScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/login.dart';
import 'package:bodhiai_teacher_flutter/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'HomePageBackground.dart';

class HomeScreen extends StatefulWidget {
  TeacherUser user = TeacherUser();
  HomeScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen(user);
  }
}

class _HomeScreen extends State<HomeScreen> {
  TeacherUser user = TeacherUser();
  _HomeScreen(this.user);
  var primaryColor = Color(0xFFF4700);
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  bool cancel = false;
  var currentPage = images.length - 1.0;
  bool toUpdate = false;
  _launchUrl(finalURL) async {
    if (await canLaunch(finalURL)) {
      await launch(finalURL);
    } else {
      throw "Could not open url";
    }
  }

  isUpdateApp(context) async {
    var currentVersion;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    //print('version ${version.toString()} ${version.runtimeType.toString()}');
    currentVersion = int.parse(version.split('.').last);
    print('current version ${currentVersion.toString()}');
    var response = await checkUpdate(user.key, currentVersion);
    if (response['status'] == 'Success') {
      setState(() {
        toUpdate = response['update'];
      });
      if (toUpdate) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'New version of this app is available with bugs fixed and new features. Do you want to update?',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.black,
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              PackageInfo packageInfo =
                                  await PackageInfo.fromPlatform();
                              String playStoreUrl =
                                  "https://play.google.com/store/apps/details?id=";
                              String packageName = packageInfo.packageName;
                              String finalURL = playStoreUrl + packageName;
                              _launchUrl(finalURL);
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    }
  }

  showLogoutDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Text('Are you sure you want to logout?',
                      style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.black,
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await preferences;
                            prefs.clear();
                            setState(() {
                              cancel = false;
                            });
                            Navigator.pop(context);
                          }),
                      RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                            cancel = true;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => isUpdateApp(context));
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              HomePageBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              user.name,
                              style: fadedTextStyle,
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                await showLogoutDialog(context);
                                if (cancel == false) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                }
                              },
                              child: Icon(Icons.settings_power,
                                  color: Colors.white, size: 30),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          user.institute,
                          style: whiteHeadingTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .07,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0),
                        child: InstituteInformation(
                          user: user,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      Mysilde(
                                          builder: (context) =>
                                              ManagementScreen(user)));
                                },
                                child: Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        AssetImage("assets/coins.png"),
                                  ),
                                  backgroundColor: Colors.pink,
                                  label: Text(
                                    'Management',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      Mysilde(
                                          builder: (context) =>
                                              MarketingScreen(user)));
                                },
                                child: Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        AssetImage("assets/marketing1.png"),
                                  ),
                                  backgroundColor: Colors.deepOrange,
                                  label: Text(
                                    'Marketing',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      Mysilde(
                                          builder: (context) =>
                                              ContentScreen(user)));
                                },
                                child: Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                        "assets/sharing-content.png"),
                                  ),
                                  backgroundColor:
                                      Colors.green.withOpacity(0.5),
                                  label: Text(
                                    'Content',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      Mysilde(
                                          builder: (context) =>
                                              CommunicationScreen(user)));
                                },
                                child: Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        AssetImage("assets/computer.png"),
                                  ),
                                  backgroundColor: Colors.blue[200],
                                  label: Text(
                                    'Communication',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'You Can ',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          CardScrollWidget(currentPage),
                          Positioned.fill(
                            child: PageView.builder(
                              itemCount: images.length,
                              controller: controller,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return Container();
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InstituteInformation extends StatelessWidget {
  const InstituteInformation({
    Key key,
    @required this.user,
  }) : super(key: key);

  final TeacherUser user;
  getInstituteInformation(key) {
    var information = instituteInformation(key);
    //print(information);

    return information;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInstituteInformation(user.key),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          var finalData = snapshot.data;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white.withOpacity(0.90),
            elevation: 20,
            child: Container(
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/reader.png',
                              height: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                'Students: ' +
                                    finalData['numberStudents'].toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/class1.png',
                              height: 25,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                'Batches: ' +
                                    finalData['numberBatches'].toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class HomePageButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
            color: Colors.white,
            child: ListTile(
              title: Text('All Students'),
              leading: Icon(Icons.person),
            ))
      ],
    );
  }
}

// 'vidoes/one click test.mp4',
//                         'vidoes/screenRecorder.mp4',
