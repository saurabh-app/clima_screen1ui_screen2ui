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
  final apiKey = "f2ba5b65a489fd4cdd5d0a352284a03b";
  String? cityName;
  String currentWeather = "";
  String tempInCel = "";
  String emoji = "";

  @override
  void initState() {
    super.initState();
    if (widget.weatherdata != null) {
      UpdateUI(widget.weatherdata);
    } else {
      print("Weather data is null");
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
        decoration: const BoxDecoration(
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
                      print("Near Me pressed");
                      print(widget.weatherdata['weather'][0]['main']);
                       UpdateUI(widget.weatherdata);
                    },
                    icon: const Icon(Icons.near_me, color: Colors.white, size: 30),
                  ),
                  IconButton(
                    onPressed: () async {
                      var typedCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Screen2()),
                      );
                      if (typedCityName != null && typedCityName != "") {
                        var weatherData = await getWeatherDataFromCityName(typedCityName);
                        if (weatherData != null) {
                          UpdateUI(weatherData);
                        }
                      }
                    },
                    icon: const Icon(Icons.location_on, color: Colors.white, size: 30),
                  ),
                ],
              ),
              Text(
                cityName != null && cityName!.isNotEmpty ? cityName! : "Enter City",
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                tempInCel.isNotEmpty ? "$tempInCel°C" : "--°C",
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 70)),
                    const SizedBox(width: 10),
                    Text(
                      currentWeather,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
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

  String kelvinToCel(var temp) {
    return (temp - 273.15).toStringAsFixed(2);
  }

  Future<Map<String, dynamic>?> getWeatherDataFromCityName(String cityName) async {
    var url = Uri.https('api.openweathermap.org', 'data/2.5/weather', {
      'q': cityName,
      'appid': apiKey,
    });
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }

  void UpdateUI(var weatherData) {
    try {
      var weatherId = weatherData['weather'][0]['id'];
      if (weatherId >= 200 && weatherId < 300) {
        emoji = "⛈️";
      } else if (weatherId >= 300 && weatherId < 400) {
        emoji = "🌦️";
      } else if (weatherId >= 500 && weatherId < 600) {
        emoji = "🌧️";
      } else if (weatherId >= 600 && weatherId < 700) {
        emoji = "❄️";
      } else if (weatherId >= 700 && weatherId < 800) {
        emoji = "🌫️";
      } else if (weatherId == 800) {
        emoji = "☀️";
      } else if (weatherId > 800) {
        emoji = "☁️";
      }

      setState(() {
        var temp = weatherData['main']['temp'];
        tempInCel = kelvinToCel(temp);
        currentWeather = weatherData['weather'][0]['description'];
        cityName = weatherData['name'];
      });

      print("City: $cityName, Temp: $tempInCel°C, Weather: $currentWeather, Weather ID: $weatherId");

    } catch (e) {
      print("Error in UpdateUI: $e");
    }
  }
}
