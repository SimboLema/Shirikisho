import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shirikisho/screen/chombo/ApplicantListMenu.dart';
import 'package:shirikisho/screen/chombo/ApplicationDetails.dart';
import 'package:shirikisho/screen/chombo/MkopoDialog.dart';
import 'package:shirikisho/screen/chombo/UserLoanList.dart';
import 'package:shirikisho/screen/chombo/mkopoform.dart';

class MkopoChomboServicesScreen extends StatefulWidget {
  @override
  State<MkopoChomboServicesScreen> createState() =>
      _MkopoChomboServicesScreenState();
}

class _MkopoChomboServicesScreenState extends State<MkopoChomboServicesScreen> {
  var userData;

  @override
  void initState() {
    // checkLoginStatus();
    // _getUserInfo();
    // get_If_user_is_Farmer_or_Expert();

    //listenNotifications();
    super.initState();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {}
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/shirikisho.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Divider(
                // height: 2,
                color: Colors.grey[100],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      makeItem(
                        name: "Omba Mkopo",
                        image: 'assets/mkopo/motorcycle-rafiki.png',
                        date: 1,
                        month: "FEB",
                        time: "06:00",
                        location: "City Mall",
                        index: 1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      makeItem(
                        name: "Fuatilia Mkopo",
                        image: 'assets/mkopo/followup.png',
                        date: 26,
                        month: "APR",
                        time: "20:00",
                        location: "Kijitonyama",
                        index: 2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      makeItem(
                        name: "Hakiki Mikopo",
                        image: 'assets/mkopo/hakiki.png',
                        date: 17,
                        month: "JAN",
                        time: "12:00",
                        location: "Tabata Kimanga",
                        index: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget makeItem({name, image, date, month, time, location, index}) { 
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: Container(
              height:context.height()*0.2 ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(.4),
                      Colors.black.withOpacity(.1),
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.arrow_forward, color: Colors.white),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              print(index);

              if (name == "Omba Mkopo") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MKopoDialog(),
                  ),
                );

                toasty(context, 'Coming Soon');
              } else if (name == "Fuatilia Mkopo") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoanHistoryScreen(),
                  ),
                );

                toasty(context, 'Coming Soon');
              } else if (name == "Hakiki Mikopo") {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoanRequestsWidget(),
                  ),
                );
                toasty(context, 'Coming Soon');
              }
            },
          ),
        ),
      ],
    );
  }
}
