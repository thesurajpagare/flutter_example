import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DashBoardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> futureAlbum;
  late Future<String> futureLoginCheck;
  var GUID=null;
  late SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncMethod();
  }

  //get dat from shared preferences
  void asyncMethod() async {
    prefs =  await SharedPreferences.getInstance();
    GUID= prefs.getString('GUID').toString();
    print("guid from pref"+GUID);
    
    // ....
  }


  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      child:new Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Flutter',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        futureAlbum = getLogin(context,nameController.text,passwordController.text,GUID);

                        print(nameController.text);
                        print(passwordController.text);
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                           // Navigator.of(context,rootNavigator: true).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                            //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )
    )

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



//API Call Login Post method
Future<String> getLogin(BuildContext ctx,String userName,String password,String GUID) async {
  var jsonBody = { 'username': userName,'password':password,'GUID':GUID};
  Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded"};
  final uri = Uri.parse("https://acmeitsolutions.net/projects/freightseek/api/login");
  final response = await http.post(uri, headers: headers, body: jsonBody);
  print("in future class after api"+response.body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print(data["ResponseCode"]);
    if(data["ResponseCode"]=="200" && data["Success"]=="true") {
      var message=data["Message"];
      var dataUser = data["data"];
      var Userid=dataUser["Userid"];
      var Mobile=dataUser["Mobile"];
      var Name=dataUser["Name"];
      var user_type=dataUser["user_type"];
      var Email=dataUser["Email"];
      var AccessToken=dataUser["AccessToken"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Userid',Userid);
      prefs.setString('Mobile',Mobile);
      prefs.setString('Name',Name);
      prefs.setString('user_type',user_type);
      prefs.setString('Email',Email);
      prefs.setString('AccessToken',AccessToken);
      Fluttertoast.showToast(
          msg:message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );

  //    _showMyDialog(ctx,message);
     /* print("in future class 200 " + dataGUID["GUID"]);
      String Userid = jsonObjectUser.getString("Userid");
      String Mobile = jsonObjectUser.getString("Mobile");
      String Name = jsonObjectUser.getString("Name");
      String user_type = jsonObjectUser.getString("user_type");


      String Email = jsonObjectUser.getString("Email");

      String AccesToken = jsonObjectUser.getString("AccessToken");
      if (jsonObjectUser.has("member_status")) {
        String member_status = jsonObjectUser.getString("member_status");
        if (user_type.trim().equalsIgnoreCase("carrier")) {
          System.out.println("car===" + member_status);
          sessionManager.setTransporterStatus(member_status);
        }
      }*/



    }else if(data["ResponseCode"]==400)
      {
        //print("code==="+data["ResponseCode"]);
        var datauserID=data["data"];
        String userid=datauserID["Userid"].toString();
        _showMyDialog(ctx,data["Message"],userid,GUID);
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




//API Call Logincheck Post method
Future<String> getLoginCheck(BuildContext ctx,String userID,String GUID) async {
  var jsonBody = { 'userId': userID,'GUID':GUID};
  Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded"};
  final uri = Uri.parse("https://acmeitsolutions.net/projects/freightseek/api/loginCheck");
  final response = await http.post(uri, headers: headers, body: jsonBody);
 // print("in Logincheck after api"+response.body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if(data["ResponseCode"]==200 && data["Success"]=="true") {
      print("in Logincheck after api"+response.body);
      var message=data["Message"];
      var dataUser = data["data"];
      var Userid=dataUser["Userid"];
      var Mobile=dataUser["Mobile"];
      var Name=dataUser["Name"];
      var user_type=dataUser["user_type"];
      var Email=dataUser["Email"];
      var AccessToken=dataUser["AccessToken"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Userid',Userid.toString());
      prefs.setString('Mobile',Mobile);
      prefs.setString('Name',Name);
      prefs.setString('user_type',user_type);
      prefs.setString('Email',Email);
      prefs.setString('AccessToken',AccessToken);
      Fluttertoast.showToast(
          msg:message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1
      );
    // Navigator.of(ctx,rootNavigator: true).pop();
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
            builder: (context) => DashBoardScreen()),
      );

      /* print("in future class 200 " + dataGUID["GUID"]);
      String Userid = jsonObjectUser.getString("Userid");
      String Mobile = jsonObjectUser.getString("Mobile");
      String Name = jsonObjectUser.getString("Name");
      String user_type = jsonObjectUser.getString("user_type");


      String Email = jsonObjectUser.getString("Email");

      String AccesToken = jsonObjectUser.getString("AccessToken");
      if (jsonObjectUser.has("member_status")) {
        String member_status = jsonObjectUser.getString("member_status");
        if (user_type.trim().equalsIgnoreCase("carrier")) {
          System.out.println("car===" + member_status);
          sessionManager.setTransporterStatus(member_status);
        }
      }*/



    }else if(data["ResponseCode"]=="400")
    {
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


//show already login dialog
Future<void> _showMyDialog(BuildContext context, String message,String userID,String GUID) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Text(message),
              Text('Do you want to Login on this device and logout from another device?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
            //  Navigator.of(context,rootNavigator: true).pop();
               var futureLoginCheck = getLoginCheck(context,userID,GUID);



            },
          ),
        ],
      );
    },
  );
}



