import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:weather_app/repos/weather_call.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    WeatherInfoModel weatherInfo;
    String lastFetched;
    on<FetchWeatherEvent>((event, emit) async {
      // getting data from shared preferences
      SharedPreferences sp = await SharedPreferences.getInstance();
      String? data = sp.getString("weatherData");
      lastFetched = sp.getString("lastFetched") ?? "";
      if (data != null) {
        weatherInfo = WeatherInfoModel.fromJson(jsonDecode(data));
      } else {
        weatherInfo = WeatherInfoModel(
          id: null,
          areaName: null,
          temp: null,
          minTemp: null,
          maxTemp: null,
          date: null,
          description: null,
          sunraise: null,
          sunset: null,
        );
      }
      try {
        // emiting loading state
        log('emiting loading state...');
        emit(WeatherLoadingState(
            weatherInfoModel: weatherInfo, lastFetched: lastFetched));

        // getting current location
        Position position = await _determinePosition();

        // fetching weather information
        final weatherData = await WeatherRepo.getCurrentWeatherData(
            position.latitude, position.longitude);

        // saving data to shared preferences
        await sp.setString('weatherData', jsonEncode(weatherData));
        await sp.setString('lastFetched', DateTime.now().toString());

        // getting data from shared preferences
        String? updatedData = sp.getString("weatherData");
        lastFetched = sp.getString("lastFetched") ?? "";
        if (updatedData != null) {
          weatherInfo = WeatherInfoModel.fromJson(jsonDecode(updatedData));
        }

        // emiting success state
        log('emiting success state');
        emit(WeatherSuccessState(
          weatherInfoModel: weatherInfo,
          lastFetched: lastFetched,
        ));
      } catch (e) {
        log(e.toString());
        // emiting failure state
        emit(WeatherFailureState(
            weatherInfoModel: weatherInfo, lastFetched: lastFetched));
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
