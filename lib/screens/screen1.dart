import 'dart:convert';

import 'package:clima_screen1ui_screen2ui/screens/Screen2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Screen1 extends StatefulWidget {
  final weatherdata;
  const Screen1({super.key, this.weatherdata});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  var apiKey = "f2ba5b65a489fd4cdd5d0a352284a03b";
  var cityName;
  var currentWeather;
  var tempInCel;
  var emoji = '';

  @override
  void initState() {
    super.initState();

    if (widget.weatherdata != null) {
      print(widget.weatherdata['name']);
      UpdateUI(widget.weatherdata);
    } else {
      print("Weather data is null");
      UpdateUI(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/screen1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      print("Pressed");
                    },
                    icon: const Icon(
                      Icons.near_me,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: ()  async{
                      var cityName = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Screen2()),
                      );
                      print(cityName);
                      if(cityName!=Null || cityName !=""){
                        var weatherdata = getWeatherDataFromCityName(cityName );
                        setState(() {
                          UpdateUI(widget.weatherdata);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const Text(
                "San Fansisco",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "17°C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$emoji", style: TextStyle(fontSize: 70)),
                    Text(
                      currentWeather,
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String kelvinToCel(var temp){

  //   var tempInCel=temp -273.15;
  //   String tempInString =tempInCel.toStringAsFixed(2);
  //   return tempInString;
  // }

  // void getWeatherDataFromCityName(String cityName) async{
  // //  var cityWeatherAPI = "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid={API key}";

  //   var url = Uri.https('api.openweathermap.org', 'data/2.5/weather', {
  //     'q': cityName,
  //     'appid': apiKey,
  //   });
  //   print(url);

  //   var response = await http.get(url);

  //     var data = response.body;
  //     var weatherData = jsonDecode(data);
  //     print(weatherData);
  // }

  // void UpdateUI(weatherData){
  //   print(weatherData);
  //   var weatherid=weatherData['weather'][0]['id'];
  //   if (weatherid >= 200 && weatherid < 300) {
  //     setState(() {
  //       emoji = "⛈️";
  //     });
  //   } else if (weatherid >= 300 && weatherid < 400) {
  //     setState(() {
  //       emoji = "🌦️";
  //     });
  //   } else if (weatherid >= 500 && weatherid < 600) {
  //     setState(() {
  //       emoji = "🌧️";
  //     });
  //   } else if (weatherid >= 600 && weatherid < 700) {
  //     setState(() {
  //       emoji = "❄️";
  //     });
  //   }else if (weatherid >= 700 && weatherid < 800) {
  //     setState(() {
  //       emoji = "❄️";
  //     });}
  //     else if (weatherid >= 800) {
  //     setState(() {
  //       emoji = "❄️";
  //     });
  //   }
  //   setState(() {
  //    var temp = weatherData['main']['temp'];
  //    tempInCel=kelvinToCel(temp);
  //    currentWeather=weatherData['weather'][0]['name'];
  //    cityName=weatherData['name'];
  //    });

  // }

  String kelvinToCel(var temp) {
    var tempInCel = temp - 273.15;
    return tempInCel.toStringAsFixed(
      2,
    ); // Return the temperature in Celsius, 2 decimal places
  }

  void getWeatherDataFromCityName(String cityName) async {
    var url = Uri.https('api.openweathermap.org', 'data/2.5/weather', {
      'q': cityName,
      'appid': apiKey,
    });
    print(url);

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = response.body;
        var weatherData = jsonDecode(data);
        print(weatherData);
        UpdateUI(weatherData);
      } else {
        // Handle error if response is not 200 OK
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  void UpdateUI(var weatherData) {
    if (weatherData == null) {
      print("Weather data is null");
      return;
    }

    try {
      var weatherId = weatherData['weather'][0]['id'];
      String emoji = '';
      if (weatherId >= 200 && weatherId < 300) {
        emoji = "⛈️";
      } else if (weatherId >= 300 && weatherId < 400) {
        emoji = "🌦️";
      } else if (weatherId >= 500 && weatherId < 600) {
        emoji = "🌧️";
      } else if (weatherId >= 600 && weatherId < 700) {
        emoji = "❄️";
      } else if (weatherId >= 700 && weatherId < 800) {
        emoji = "🌫️"; // Changed to fog emoji for better representation
      } else if (weatherId == 800) {
        emoji = "☀️"; // Clear weather
      } else if (weatherId > 800) {
        emoji = "☁️"; // Clouds
      }

      setState(() {
        var temp = weatherData['main']['temp'];
        tempInCel = kelvinToCel(temp);
        currentWeather =
            weatherData['weather'][0]['description']; // Corrected to 'description'
        cityName = weatherData['name'];
        var emojiSymbol = emoji; // Store the emoji based on weather id
      });
    } catch (e) {
      print("Error in UpdateUI: $e");
    }
  }
}
