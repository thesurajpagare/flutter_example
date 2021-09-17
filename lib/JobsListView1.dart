import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Quote {
  final String id;
  final String amount;
  final String vehicle_type;
  final String status;

  Quote(
      {required this.id,
      required this.amount,
      required this.vehicle_type,
      required this.status});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      amount: json['amount'],
      vehicle_type: json['vehicle_type'],
      status: json['status'],
    );
  }
}

class JobsListView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchJobs(),
      builder: (context, AsyncSnapshot snapshot) {
        print("in future");
        print("in snapshot==" + snapshot.hasData.toString());
        if (snapshot.hasData) {
          print("in snapshot==" + snapshot.data.toString());
          //  print( "val="+snapshot.data.toString());
          List<Quote>? data = snapshot.data;
          //  print("val=="+data.toString());
          return _jobsListView(data!);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future _fetchJobs() async {
    var cats;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String AccessToken = prefs.getString('AccessToken').toString();
    String userID = prefs.getString('Userid').toString();
    String user_type = prefs.getString('user_type').toString();
    print("token===" + AccessToken + "userid==" + userID);
    //  final jobsListAPIUrl = 'https://acmeitsolutions.net/projects/freightseek/api/getStatesCat/8';
    final jobsListAPIUrl =
        "https://acmeitsolutions.net/fs/qa/api/freight/quotelist";

    var jsonBody = {
      'userId': userID,
      'freight_id': '8',
      'lowerlimit': '0',
      'user_type': user_type
    };
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      /*"Content-type": "header",*/
      "accesstoken": AccessToken
    };

    final response = await http.post(Uri.parse(jobsListAPIUrl),
        body: jsonBody,
        headers: headers,
        encoding: Encoding.getByName('utf-8'));
    print("val====");
    var data = json.decode(response.body);
    print("val====" + data.toString());
    //print(json.decode(response.body).toString());
    cats = data["data"];
    print(cats);
    if (response.statusCode == 200) {
      List cats = data["data"];
      //print(cats);
      // List lst =cats;
      List<Quote> catNameList = [];
      for (int i = 0; i < cats.length; i++) {
        var idValue = cats[i]["id"];
        var vehicle_typeValue = cats[i]["vehicle_type"];
        var amountValue = cats[i]["amount"];
        var statusValue = cats[i]["status"];
        print("val=12=" + idValue.toString());
        Quote quote = new Quote(
            id: idValue.toString(),
            amount: amountValue.toString(),
            vehicle_type: vehicle_typeValue,
            status: statusValue);
        catNameList.add(quote);
        print("val=12=" + idValue.toString());
      }
      Quote quote1 = new Quote(
          id: "2", amount: "500", vehicle_type: "truck", status: "accepted");
      catNameList.add(quote1);
      Quote quote2 = new Quote(
          id: "3", amount: "700", vehicle_type: "truck", status: "declined");
      catNameList.add(quote2);
      // List jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      print("size==" + catNameList.length.toString());
      return catNameList;
      //return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(List<Quote> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index], "", Icons.work);
        });
  }

  Card _tile(Quote data, String subtitle, IconData icon) => Card(
      margin: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Quote Amount:",
                      ),
                      SizedBox(height: 2),
                      Text(data.amount,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Transporter Provider:"),
                      Row(children: <Widget>[
                        CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage('images/car.png'),
                        backgroundColor: Colors.transparent,
                      ),
                        /*Image(image: AssetImage('images/freightseek.png'),height: 25,width: 25),*/
                        SizedBox(width: 10),
                        Column(children: <Widget>[


                          Text("Pagare & Sons",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                        ],)


                      ],),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text("Expiry Date:"),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("Messages:"),
                          )
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("10 AUg 2021",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("10 AUg 2021",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]),
                      SizedBox(height: 5),
                      Text("Vehicle:"),
                      SizedBox(height: 2),
                      Text(data.vehicle_type,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Status:"),
                      SizedBox(height: 2),
                      Text(data.status,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          //Spacer(),
                          Expanded(

                            flex: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                              child: Text('Decline Quote'),
                              onPressed: () => null,
                            ),
                          ),
                          SizedBox(width: 10), //for spacing
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              child: Text('Accept Quote'),
                              onPressed: () => null,
                            ),
                          )
                        ],
                      )
                    ]))
          ]));
}
