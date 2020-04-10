import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/FeatureHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePackage extends StatefulWidget {
  TeacherUser user = TeacherUser();
  CreatePackage(this.user);

  @override
  _CreatePackageState createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Create Package'),
      //   backgroundColor: Color(0xFFFF4700).withOpacity(0.95),
      // ),
      body: SafeArea(
              child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FeatureHomeScreen(
                screenHeight: MediaQuery.of(context).size.height,
                screenName: 'Create Package',
              ),
               Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Color(0xFFFF4700),)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFFF4700),),
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Name of Package'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFFFF4700),)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Price of Package (in Rupees)'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFFFF4700),)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Duration of Package(in Days)'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    MaterialButton(
                        height: 50,
                        minWidth: 100,
                        color: Color(0xFFFF4700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Create Package",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () async {
                          print(titleController.text.toString());
                          print(priceController.text.toString());
                          print(durationController.text.toString());

                          var response = await createPackage(
                              widget.user.key,
                              titleController.text,
                              priceController.text,
                              durationController.text);
                          print('create package response ${response.toString}');

                          if (response['status'] == 'Success') {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Package Successfully created !!',
                                     gravity: ToastGravity.CENTER,
                                      textColor: Colors.orange,);
                                
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
