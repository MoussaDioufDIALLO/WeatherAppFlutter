import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/controlers/currentWeather.dart';
import 'package:weather/controlers/delayed_animation.dart';
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
                delay: 2500,
                child: Container(
                  margin: EdgeInsets.only(
                      top: 30,
                      bottom: 20
                  ),
                  child: Text(
                    "Soyez à jour avec les dernières conditions météorologiques et soyez prêt pour n'importe quelle prévision. Obtenez des informations précises sur la température, le vent et les précipitations pour planifier votre journée en conséquence.",
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
                    child: Text('COMMENCER'),
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