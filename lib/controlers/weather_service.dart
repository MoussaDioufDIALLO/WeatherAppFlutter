import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:weather/models/weather.dart';
import 'package:retrofit/http.dart';


part 'weather_service.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class WeatherService {
  factory WeatherService(Dio dio, {String baseUrl}) = _WeatherService;

  @GET("weather")
  Future<Weather> getWeatherData(
      @Query("q") String city,
      @Query("appid") String apiKey,
      @Query("units") String units,
      );
}
