import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CreatePackage.dart';
import 'package:bodhiai_teacher_flutter/screens/FeatureHomeScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/IndividualPackages.dart';
import 'package:flutter/material.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';

class Packages extends StatefulWidget {
  TeacherUser user = TeacherUser();

  Packages(this.user);

  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  var packages;
  bool isPackages = false;
  _PackagesState();

  getPackagesPage(key) async {
    var packages = await getCreatedPackages(key);
    return packages;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('is packages ${isPackages.toString()}');
    print('build packages ${packages.toString()}');
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Packages'),
        backgroundColor: Color(0xFFFF4700).withOpacity(0.95)
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF4700).withOpacity(0.95),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePackage(
                        widget.user,
                      )));
        },
        child: Icon(
          Icons.add,
          size: 50,
          
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getPackagesPage(widget.user.key),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Column(
                children: <Widget>[Text('No Packages Found')],
              );
            } else {
              var packages = snapshot.data['packages'];
              return ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image(image:  AssetImage("assets/pakage.png"),height: 30,width: 30,),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          packages[index]['title'].replaceAll("\"", ''),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Price: ' + packages[index]['price'].toString()),
                          Text('Duration: ' +
                              packages[index]['duration'].toString()),
                          Text('Purchased: ' +
                              packages[index]['number_students'].toString()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 5,
                              color: Color(0xFFFF4700),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        int packageId = packages[index]['id'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IndividualPackages(
                                    widget.user, packageId)));
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
