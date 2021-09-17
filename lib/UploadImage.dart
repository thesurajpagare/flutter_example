import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyImagePicker(title: 'Upload image'),
    );
  }
}

class MyImagePicker extends StatefulWidget {
  MyImagePicker({required this.title}) ;
  final String title;

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  PickedFile ?_imageFile;
  final String uploadUrl = 'https://acmeitsolutions.net/fs/qa/api/updateUserProfileImage';
  final ImagePicker _picker = ImagePicker();

  Future uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String AccessToken= prefs.getString('AccessToken').toString();
    String Userid= prefs.getString('Userid').toString();
    String UserName= prefs.getString('Name').toString();
    print("name=="+UserName+"id=="+Userid+"fpath=="+filepath);
    request.fields['userId'] = Userid;
    request.headers['accesstoken'] = AccessToken;
  //  request.fields['userId'] = Userid;
    request.files.add(await http.MultipartFile.fromPath('profile_image', filepath));
    var res = await request.send().then((response) {
      if (response.statusCode == 200) {
        print("Uploaded!");
        print("response==" + response.reasonPhrase.toString());
      }
    });
   // return res.toString();
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ' + response.exception!.code);
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(File(_imageFile!.path),height: 100,width: 100,),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                var res = await uploadImage(_imageFile!.path, uploadUrl);
                //print(res);
              },
              child: const Text('Upload'),
            )
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<void>(
            future: retriveLostData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Text('Picked an image');
                case ConnectionState.done:
                  return _previewImage();
                default:
                  return const Text('Picked an image');
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image from gallery',
        child: Icon(Icons.photo_library),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}