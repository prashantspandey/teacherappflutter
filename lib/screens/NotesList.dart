import 'dart:io';

import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/NoteWebView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bodhiai_teacher_flutter/screens/NotesViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class NotesList extends StatelessWidget {
  TeacherUser user = TeacherUser();
  var notes;
  NotesList(this.user,this.notes);


  showDeleteDialog(context,noteId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 200,child: Column(children: <Widget>[
        Text('Are you sure you want to delete this note?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Delete',style:TextStyle(color: Colors.white)), onPressed: ()async {
            var response = await postDeleteNote(user.key, noteId);
            Fluttertoast.showToast(msg: response['message']);
            Navigator.pop(context);
          },),
          RaisedButton(color: Colors.white,child: Text('Cancel',style:TextStyle(color: Colors.black)), onPressed: () {Navigator.pop(context);},)
        ],)
      ],),),);
    });
  }
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize();

    print('final notes ${notes[0].toString()}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes List'),
        backgroundColor: Colors.green
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                notes[index]['title'],
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      child: Image(
                        image: AssetImage("assets/paper.png"),
                      )),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Divider(
                  //   height: 5,
                  //   color: Colors.grey,
                  // ),
                  Text(notes[index]['subject_name'],style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(notes[index]['chapter_name'],style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              trailing: Text(
                notes[index]['publishDate'].split('T')[0].toString(),
                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                print('notes opening');
                print('note url ${notes[index]["note_url"][0]}');
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteWebView("https://docs.google.com/viewer?url="+notes[index]['note_url'][0].toString())));

              },
              onLongPress: ()async{
                  int noteId = notes[index]['id'];
                  await showDeleteDialog(context,noteId);
                  Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
