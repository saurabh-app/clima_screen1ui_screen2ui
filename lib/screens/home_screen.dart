import 'dart:convert';

import 'package:clima_screen1ui_screen2ui/screens/screen1.dart';
import 'package:clima_screen1ui_screen2ui/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
if(mounted){
  getLoction();
}    super.initState();
  }

  void getLoction() async {
    Location location = Location();
    await location.getCurrentLocation();
    double lat = location.latitude;
    double lon = location.longitude;
    var apiKey = "f2ba5b65a489fd4cdd5d0a352284a03b";
  //   var apiUrl ="https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}";
//print(apiUrl);
    var url = Uri.https('api.openweathermap.org', 'data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': apiKey,
    });
    print(url);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      Navigator.push(context, MaterialPageRoute(builder: (_)=>Screen1() ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.grey,
          size: 50,
        )
      ),
    );
  }
}