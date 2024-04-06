part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoadingState extends WeatherState {
  final WeatherInfoModel weatherInfoModel;
  final String lastFetched;
  const WeatherLoadingState(
      {required this.weatherInfoModel, required this.lastFetched});
}

final class WeatherFailureState extends WeatherState {
  final WeatherInfoModel weatherInfoModel;
  final String lastFetched;
  const WeatherFailureState(
      {required this.weatherInfoModel, required this.lastFetched});
}

final class WeatherSuccessState extends WeatherState {
  final WeatherInfoModel weatherInfoModel;
  final String lastFetched;
  const WeatherSuccessState({
    required this.weatherInfoModel,
    required this.lastFetched,
  });
}
