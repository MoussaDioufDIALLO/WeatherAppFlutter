import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:weather/controlers/weather_service.dart';
import 'package:weather/models/weather.dart';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  List<Weather> weatherList = [];
  bool showWeatherData = false;
  bool isDataLoaded = false;
  RxDouble currentPercentage = RxDouble(0.0);
  bool isProgressComplete = false;
  List<String> messages = [
    "Nous téléchargeons les données...",
    "C'est presque fini...",
    "Plus que quelques secondes avant d'avoir le résultat..."
  ];
  int currentMessageIndex = 0;

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
    startMessageRotation();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  late Timer timer;

  void startMessageRotation() {
    timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (currentPercentage.value < 100 || isProgressComplete == false) {
        setState(() {
          currentMessageIndex = (currentMessageIndex + 1) % messages.length;
        });
      } else {
        setState(() {
          currentMessageIndex = 0;
        });
      }
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
            Text(
              currentPercentage.value < 100
                  ? messages[currentMessageIndex]
                  : '',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (currentPercentage.value == 100.0) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPercentage.value = 0.0;
                          isProgressComplete = false;
                          showWeatherData = false;
                          currentMessageIndex = 0; // Réinitialiser currentMessageIndex à 0
                          if (timer.isActive) {
                            timer.cancel();
                          }
                          startProgressAnimation();
                          startMessageRotation(); // Ajout de cette ligne pour redémarrer la rotation des messages
                        });
                      },

                      child: Text('Recommencer'),
                    ),
                    SizedBox(height: 20),
                    if (showWeatherData && isDataLoaded && isProgressComplete)
                      ...weatherList.map(
                            (weather) =>
                            Card(
                              child: ListTile(
                                title: Text("${weather.city}"),
                                subtitle: Row(
                                  children: [
                                    Icon(getCloudIcon(weather.clouds)),
                                    SizedBox(width: 10),
                                    Text(
                                      "${weather.temp}°C | ${weather.description} | H:${weather.high}°C L:${weather.low}°C",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                  ],
                );
              } else {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearPercentIndicator(
                        width: 250,
                        lineHeight: 30,
                        percent: currentPercentage.value / 100,
                        center: Text(
                          '${currentPercentage.value.toStringAsFixed(0)}%',
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
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  void startProgressAnimation() async {
    await Future.delayed(Duration(seconds: 0));
    const updateInterval = Duration(milliseconds: 600);
    final steps = 100;

    setState(() {
      currentMessageIndex = 0;
      isProgressComplete = false;
      showWeatherData = false;
    });

    for (int i = 0; i <= steps; i++) {
      await Future.delayed(updateInterval);
      currentPercentage.value = i.toDouble();
    }

    setState(() {
      isProgressComplete = true;
      showWeatherData = true;
      currentMessageIndex = 0; // Réinitialiser l'index des messages à 0
    });
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
    List<String> cities = [
      'Ziguinchor',
      'Paris',
      'Londres',
      'Dubai',
      'New York'
    ];
    String apiKey = "439886ca1e86859b9393c749a1bebf92";
    List<Weather> weatherList = [];

    final weatherService = WeatherService(Dio());

    for (var city in cities) {
      try {
        Weather weather = await weatherService.getWeatherData(
            city, apiKey, "metric");
        weatherList.add(weather);
      } catch (e) {
        print(
            "Erreur lors de la récupération des données pour la ville $city: $e");
      }
    }

    setState(() {
      showWeatherData = true;
      currentMessageIndex = 0; // Réinitialiser l'index des messages à 0
    });

    return weatherList;
  }
}
