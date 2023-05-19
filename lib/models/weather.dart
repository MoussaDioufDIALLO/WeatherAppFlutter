class Weather {
  final String? city;
  final double? temp;
  final double? feelsLike;
  final double? low;
  final double? high;
  final String? description;
  final int clouds;
  final double windSpeed; // ajout de la propriété windSpeed

  Weather({
    this.city,
    this.temp,
    this.feelsLike,
    this.low,
    this.high,
    this.description,
    required this.clouds,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      clouds: json['clouds'] != null ? json['clouds']['all'] : 0,
      windSpeed: json['wind']['speed'].toDouble(), // récupération de la propriété windSpeed
    );
  }
}
