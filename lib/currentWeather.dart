import 'package:flutter/material.dart';
import 'package:weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  List<Weather>? _weathers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Weather'),
      ),
      body: Center(
        child: FutureBuilder<List<Weather>>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                _weathers = snapshot.data;
              }
              if (_weathers == null) {
                return Text("Error getting weather");
              } else {
                return weatherBox(_weathers!);
              }
            } else {
              return CircularProgressIndicator();
            }
          },
          future: fetchWeatherData(),
        ),
      ),
    );
  }
}
Widget weatherBox(List<Weather> weatherList) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                width: 250,
                lineHeight: 30,
                percent: 1,
                center: Text(
                  '100%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                barRadius: Radius.circular(10),
                progressColor: Colors.redAccent,
                backgroundColor: Colors.indigo,
                animation: true,
                animationDuration: 60000,
              ),
            ],
          ),
          SizedBox(height: 20),
          ...weatherList.map((weather) => Card(
            child: ListTile(
              title: Text("${weather.city}"),
              subtitle: Row(
                children: [
                  Icon(getCloudIcon(weather.clouds)),
                  SizedBox(width: 10),
                  Text(
                      "${weather.temp}°C | ${weather.description} | H:${weather.high}°C L:${weather.low}°C"),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    ),
  );
}

IconData getCloudIcon(int clouds) { // Fonction pour obtenir l'icône correspondante
  if (clouds < 20) {
    return Icons.wb_sunny;
  } else if (clouds < 60) {
    return Icons.wb_cloudy;
  } else {
    return Icons.cloud;
  }
}



Future<List<Weather>> fetchWeatherData() async {
  List<String> cities = ['Kolda', 'Paris', 'Londres', 'Dubai', 'New York'];
  String apiKey = "439886ca1e86859b9393c749a1bebf92";
  List<Weather> weatherList = [];

  for (var city in cities) {
    var url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      weatherList.add(Weather.fromJson(jsonDecode(response.body)));
    }
  }

  return weatherList;
}
