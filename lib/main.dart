import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_Screen.dart';
import 'package:http/http.dart' as http;
import 'DashBoardScreen.dart';
import 'Login_Screen.dart';
import 'dart:async';


void main() { runApp(MyApp());}

class MyApp extends StatelessWidget {

  //late Future<Album> futureAlbum;
 /* @override
  void initState() {
    //super.initState();
    //super.initState();
    futureAlbum = fetchAlbum();
  }*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    /*Future<void> initState() async {*/
    super.initState();
    asyncMethod();
  }

    //if()

 // }


  void asyncMethod() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var GUID= prefs.getString('GUID').toString();
    var userId= prefs.getString('Userid').toString();
    print("guid from pref"+GUID+" "+userId);
    if(GUID == null || GUID == "null" || GUID == "")
    {
      var futureAlbum = fetchAlbum(context);

    }else if(userId==null || userId == "null" || userId == "")
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage()),
        );
      }

    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
      );
    }

    // ....
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image(
            image:AssetImage('images/freightseek.png'),
         width: 150,
          height: 150,
            fit:BoxFit.fill
          //child:FlutterLogo(size:MediaQuery.of(context).size.height)
        )
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Splash Screen Example")),
      body: Center(
          child:Text("Welcome to Home Page",
              style: TextStyle( color: Colors.black, fontSize: 30)
          )
      ),
    );
  }
}


//API Call Post method
Future<String> fetchAlbum(BuildContext ctx) async {
  var jsonBody = { 'GUID': 'NEW'};
  Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded"};
  var baseUrl = 'http://acmeitservices.com/projects/freightseek/api/';
  //final uri = Uri.parse("https://acmeitsolutions.net/projects/freightseek/api/registerDevice");
  final uri = Uri.parse("https://acmeitsolutions.net/fs/qa/api/registerDevice");
  final response = await http.post(uri, headers: headers, body: jsonBody);
  print("in future class after api"+response.body);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var dataGUID = data["data"];
    print("in future class 200 "+dataGUID["GUID"]);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('GUID', dataGUID["GUID"]);
    print("pref getstring=="+prefs.getString("GUID").toString());
   final BuildContext context;
    Timer(Duration(seconds: 5),
            ()=>Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => LoginPage()
            )
        )
    );
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return "";
    //return Album.fromJson(jsonDecode(response.body));
  } else {
    print("in future class excption ");
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

/*
void main() {
  runApp(
   MyApp()
  );


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.blueAccent,
          appBar: AppBar(
            title: Text('Flutter'),
            backgroundColor: Colors.amberAccent,
          ),
          body: Center(
              child: Image(
                image: AssetImage(
                    './images/logo.png'
                ),
                width: 200,
                height: 200,
              )
          ),
        )
    );
  }
}




*/
