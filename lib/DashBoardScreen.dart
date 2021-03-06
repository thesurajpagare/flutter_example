import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_testing_app/JobsListView1.dart';
import 'package:flutter_testing_app/Login_Screen.dart';
import 'package:flutter_testing_app/UploadSingleFile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'UploadFile.dart';
import 'UploadImage.dart';

/*
class DashBoardScreen extends StatelessWidget {

  static const appTitle = 'Drawer Demo';
  //const DashBoardScreen({Key? key, required this.title}) : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    child:new Scaffold(
      appBar: AppBar(title:Text("DashBoard"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 1000), () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              });
          },
          ),
      ),

      body: Center(
          child:Text("Welcome to Dashboard",
              style: TextStyle( color: Colors.black, fontSize: 30)
          )
      ),
    ),
      onWillPop: () async {
        Future.delayed(const Duration(milliseconds: 1000), () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return false;
      },

    );

  }
}

*/

//void main() => runApp(const MyApp());

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  DashBoardScreenPage createState()=> DashBoardScreenPage();

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
    //  home: DashBoardScreenPage(),
    );
  }
}
int _selectedIndex = 0;
class DashBoardScreenPage  extends State<DashBoardScreen> {
 // const DashBoardScreenPage() : super();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: My Booking',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];
  // final String title;

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==0)
      {

      }
      else if(_selectedIndex==1)
      {
        Navigator.push(
          context,
          MaterialPageRoute( builder: (context) => MyImagePicker(
            title: 'Upload Image',
          )),
        );
      }
      else
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadSingleFile()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: JobsListView1(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Upload Image',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Upload File',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      //getListView(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyImagePicker(
                            title: 'Upload Image',
                          )),
                );
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Upload File'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadSingleFile()),
                );
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var GUID = prefs.getString('GUID').toString();
                var userId = prefs.getString('Userid').toString();
                _showMyDialog(
                    context,
                    "Are you sure you want to log out from this phone?",
                    userId,
                    GUID);
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

//show already login dialog
  Future<void> _showMyDialog(
      BuildContext context, String message, String userID, String GUID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text(''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () async {
                //  Navigator.of(context,rootNavigator: true).pop();
                var futureLoginCheck = getLogout(context, userID, GUID);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

//API Call Logincheck Post method
  Future<String> getLogout(BuildContext ctx, String userID, String GUID) async {
    var jsonBody = {'userId': userID, 'GUID': GUID};
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    final uri = Uri.parse(
        "https://acmeitsolutions.net/projects/freightseek/api/logout");
    final response = await http.post(uri, headers: headers, body: jsonBody);
    // print("in Logincheck after api"+response.body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["ResponseCode"] == 200 && data["Success"] == "true") {
        print("in logout after api" + response.body);
        var message = data["Message"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Userid', "");
        prefs.setString('Mobile', "");
        prefs.setString('Name', "");
        prefs.setString('user_type', "");
        prefs.setString('Email', "");
        prefs.setString('AccessToken', "");
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1);
        // Navigator.of(ctx,rootNavigator: true).pop();
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (data["ResponseCode"] == "400") {
        //  _showMyDialog(ctx,data["Message"],);
      }

      // "ResponseCode":400,

      return "";
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      print("in future class excption ");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

List<String> getListElements() {
  var items = List<String>.generate(1000, (counter) => "Item $counter");
  return items;
}

Widget getListView() {
  var listItems = getListElements();

  var listview = ListView.builder(itemBuilder: (context, index) {
    return ListTile(
      title: Text(listItems[index]),
    );
  });
  return listview;
}

//API Call for list
Future<String> getLoginCheck(
    BuildContext ctx, String userID, String GUID) async {
  var jsonBody = {'userId': userID, 'GUID': GUID};
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };
  final uri = Uri.parse(
      "https://acmeitsolutions.net/projects/freightseek/api/loginCheck");
  final response = await http.post(uri, headers: headers, body: jsonBody);
  // print("in Logincheck after api"+response.body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data["ResponseCode"] == 200 && data["Success"] == "true") {
      print("in Logincheck after api" + response.body);
      var message = data["Message"];
      var dataUser = data["data"];
      var Userid = dataUser["Userid"];
      var Mobile = dataUser["Mobile"];
      var Name = dataUser["Name"];
      var user_type = dataUser["user_type"];
      var Email = dataUser["Email"];
      var AccessToken = dataUser["AccessToken"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Userid', Userid.toString());
      prefs.setString('Mobile', Mobile);
      prefs.setString('Name', Name);
      prefs.setString('user_type', user_type);
      prefs.setString('Email', Email);
      prefs.setString('AccessToken', AccessToken);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1);
      // Navigator.of(ctx,rootNavigator: true).pop();
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
      );
    } else if (data["ResponseCode"] == "400") {
      //  _showMyDialog(ctx,data["Message"],);
    }

    // "ResponseCode":400,

    return "";
    //return Album.fromJson(jsonDecode(response.body));
  } else {
    print("in future class excption ");
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
