class WeatherModel {
  double? temp;
  String? description;
  String? locationName;

  WeatherModel({this.temp, this.locationName, this.description});

  static WeatherModel fromjason(Map map) {
    String? description;

    List weather = map["weather"] ?? [];
    if (weather.isNotEmpty) {
      Map temp = weather[0];
      description = "${temp["description"]}";
    }

    return WeatherModel(
        temp: map["main"]["temp"],
        description: description,
        locationName: map["name"]);
  }
}
