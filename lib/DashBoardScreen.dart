import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashBoardScreen extends StatelessWidget {
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
