import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherRepo {
  static Future<Map<String, dynamic>> getCurrentWeatherData(
      double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${dotenv.env["WEATHER_API"]}"));

      if (response.statusCode == 200) {
        log(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Return the data
        return data;
      } else {
        throw Exception("something wewnt wrong");
      }
    } catch (e) {
      throw Exception('Failed to fetch data from API: $e');
    }
  }
}
