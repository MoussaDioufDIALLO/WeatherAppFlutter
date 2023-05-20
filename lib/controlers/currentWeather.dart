import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:weather/controlers/weather_service.dart';
import 'package:weather/main.dart';
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
  List<String> topMessages = [
    "Nous téléchargeons les données...",
    "C'est presque fini...",
    "Plus que quelques secondes avant d'avoir le résultat..."
  ];
  int currentTopMessageIndex = 0;
  int currentBottomMessageIndex = 0;
  Timer? timerTop;
  Timer? timerBottom;

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
    timerTop?.cancel();
    timerBottom?.cancel();
  }

  void startMessageRotation() {
    timerTop = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (currentPercentage.value < 100 || isProgressComplete == false) {
        setState(() {
          if (currentPercentage.value < 100) {
            currentTopMessageIndex =
                (currentTopMessageIndex + 1) % topMessages.length;
          }
        });
      } else {
        setState(() {
          currentTopMessageIndex = 0;
        });
      }
    });

    timerBottom = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      if (currentPercentage.value < 100 || isProgressComplete == false) {
        setState(() {
          if (currentPercentage.value < 100) {
            currentBottomMessageIndex =
                (currentBottomMessageIndex + 1) % weatherList.length;
          }
        });
      } else {
        if (currentBottomMessageIndex < weatherList.length) {
          Weather weather = await fetchWeatherDataForCity(
              weatherList[currentBottomMessageIndex]?.city ?? '');
          setState(() {
            weatherList[currentBottomMessageIndex] = weather;
          });
        }
        setState(() {
          currentBottomMessageIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
        backgroundColor: d_red,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Obx(() {
              return Text(
                currentPercentage.value < 100
                    ? topMessages[currentTopMessageIndex]
                    : '',
                style: TextStyle(fontSize: 18),
              );
            }),
            SizedBox(height: 20),
            Obx(() {
              if (currentPercentage.value == 100.0) {
                return Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: d_red,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(13),
                        minimumSize: Size(350, 0),
                      ),
                      onPressed: () {
                        setState(() {
                          currentPercentage.value = 0.0;
                          isProgressComplete = false;
                          showWeatherData = false;
                          currentTopMessageIndex = 0;
                          currentBottomMessageIndex = 0;
                          timerTop?.cancel();
                          timerBottom?.cancel();
                          startProgressAnimation();
                          startMessageRotation();
                        });
                      },
                      child: Text('Recommencer'),
                    ),
                    SizedBox(height: 20),
                    if (showWeatherData && isDataLoaded && isProgressComplete)
                      Column(
                        children: weatherList.map((weather) {
                          return Card(
                            child: ListTile(
                              title: Text("${weather.city ?? ''}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(getCloudIcon(weather.clouds)),
                                      SizedBox(width: 10),
                                      Text(
                                        "${weather.temp}°C | ${weather.description} | H:${weather.high}°C L:${weather.low}°C",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.air),
                                      SizedBox(width: 10),
                                      Text(
                                        "${weather.windSpeed} m/s",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          LinearPercentIndicator(
                            width: 410,
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
                            progressColor: d_red,
                            backgroundColor: Colors.indigo,
                            animation: true,
                            animateFromLastPercent: true,
                            animationDuration: 60000,
                          ),
                          SizedBox(height: 20),
                          Text(
                            weatherList.isNotEmpty ? "${weatherList[currentBottomMessageIndex]?.city ?? ''} | ${weatherList[currentBottomMessageIndex]?.description ?? ''} | Température: ${weatherList[currentBottomMessageIndex]?.temp ?? ''}°C | Vitesse du vent: ${weatherList[currentBottomMessageIndex]?.windSpeed ?? ''} m/s" : '',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
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
      currentTopMessageIndex = 0;
      currentBottomMessageIndex = 0;
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
      currentTopMessageIndex = 0;
      currentBottomMessageIndex = 0;
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

  Future<Weather> fetchWeatherDataForCity(String city) async {
    String apiKey = "439886ca1e86859b9393c749a1bebf92";

    final weatherService = WeatherService(Dio());

    try {
      Weather weather = await weatherService.getWeatherData(city, apiKey, "metric");
      return weather;
    } catch (e) {
      print("Erreur lors de la récupération des données pour la ville $city: $e");
      throw e;
    }
  }

  Future<List<Weather>> fetchWeatherData() async {
    List<String> cities = ['Ziguinchor', 'Paris', 'Londres', 'Dubai', 'New York'];
    String apiKey = "439886ca1e86859b9393c749a1bebf92";
    List<Weather> weatherList = [];

    final weatherService = WeatherService(Dio());

    for (var city in cities) {
      try {
        Weather weather = await weatherService.getWeatherData(city, apiKey, "metric");
        weatherList.add(weather);
      } catch (e) {
        print("Erreur lors de la récupération des données pour la ville $city: $e");
      }
    }

    setState(() {
      showWeatherData = true;
      currentTopMessageIndex = 0;
      currentBottomMessageIndex = 0;
    });

    return weatherList;
  }
}
