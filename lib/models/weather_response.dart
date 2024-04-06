class WeatherInfoModel {
  final int? id;
  final String? areaName;
  final double? temp;
  final double? minTemp;
  final double? maxTemp;
  final int? date;
  final String? description;
  final DateTime? sunraise;
  final DateTime? sunset;

  WeatherInfoModel({
    required this.id,
    required this.areaName,
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.date,
    required this.description,
    required this.sunraise,
    required this.sunset,
  });

  factory WeatherInfoModel.fromJson(Map<String, dynamic>? data) {
    return WeatherInfoModel(
      id: data?['weather'].first['id'],
      areaName: data?['name'],
      temp: data?['main']['temp'] - 273.15,
      minTemp: data?['main']['temp_min'] - 273.15,
      maxTemp: data?['main']['temp_max'] - 273.15,
      date: data?['dt'],
      description: data?['weather'].first['main'].toUpperCase(),
      sunraise:
          DateTime.fromMillisecondsSinceEpoch(data?['sys']['sunrise'] * 1000),
      sunset:
          DateTime.fromMillisecondsSinceEpoch(data?['sys']['sunset'] * 1000),
    );
  }
  @override
  String toString() {
    String string = "sunrise Date:$sunraise \nsunset Date: $sunset";
    return string;
  }
}
