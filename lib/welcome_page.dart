import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/currentWeather.dart';
import 'package:weather/delayed_animation.dart';
import 'package:weather/main.dart';


class WelcomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 30,
          ),
          child: Column(
            children: [DelayedAnimation(
                delay: 1500,
                child: Container(
                  margin:EdgeInsets.only(top:180),
                  height: 170,
                  child: Image.asset('images/neige.png'),
                )
            ),
              DelayedAnimation(
                delay: 3500,
                child: Container(
                  margin: EdgeInsets.only(
                      top: 30,
                      bottom: 20
                  ),
                  child: Text(
                    "Stay up-to-date with the latest weather conditions and be prepared for any forecast. Get accurate information on temperature, wind, and precipitation so you can plan your day accordingly.",
                    style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
              DelayedAnimation(
                delay: 2500,
                child: Container(
                  width: double.infinity,
                  child:ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        backgroundColor: d_red,
                        shape:  StadiumBorder(),
                        padding: EdgeInsets.all(13)
                    ),
                    child: Text('GET STARTED'),
                    onPressed:() {
                      /*  Navigator.push(context, MaterialPageRoute(builder: (context) => SocialPage(),
                              Get.to(SocialPage());
                           ),
                          );*/   Get.to(CurrentWeatherPage());

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}