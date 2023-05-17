import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  List<Weather> weatherList = [];
  bool showWeatherData = false;
  bool isDataLoaded = false;
  double currentPercentage = 0.0;
  bool isProgressComplete = false;

  @override
  void initState() {
    super.initState();
    startProgressAnimation();
    fetchWeatherData().then((weatherList) {
      setState(() {
        this.weatherList = weatherList;
        isDataLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Current Weather'),
        ),
        body: Center(
            child: Column(
                children: [
                SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  width: 250,
                  lineHeight: 30,
                  percent: currentPercentage / 100,
                  center: Text(
                    '${currentPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  barRadius: Radius.circular(10),
                  progressColor: Colors.redAccent,
                  backgroundColor: Colors.indigo,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 60000,
                ),
              ],
            ),
                  SizedBox(height: 20),
                  if (showWeatherData && isDataLoaded && isProgressComplete)
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
                    )),
                ],
        ),
      ),
    );
  }

  void startProgressAnimation() async {
    await Future.delayed(Duration(seconds: 0));
    const updateInterval = Duration(milliseconds: 600);
    final steps = 100;

    for (int i = 0; i <= steps; i++) {
      await Future.delayed(updateInterval);
      setState(() {
        currentPercentage = i.toDouble();
      });

      if (currentPercentage >= 100 && !isProgressComplete) {
        isProgressComplete = true;
        break;
      }
    }
  }


  IconData getCloudIcon(int clouds) {
    if (clouds < 20) {
      return Icons.wb_sunny;
    } else if (clouds < 60) {
      return Icons.wb_cloudy;
    } else {
      return Icons.cloud;
    }
  }

  Future<List<Weather>> fetchWeatherData() async {
    List<String> cities = ['Ziguinchor', 'Paris', 'Londres', 'Dubai', 'New York'];
    String apiKey = "439886ca1e86859b9393c749a1bebf92";
    List<Weather> weatherList = [];

    for (var city in cities) {
      var url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        weatherList.add(Weather.fromJson(jsonDecode(response.body)));
      }
    }

    setState(() {
      showWeatherData = true;
    });

    return weatherList;
  }
}