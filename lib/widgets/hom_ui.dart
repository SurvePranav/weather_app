import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/models/weather_response.dart';

class HomeScreenUI extends StatefulWidget {
  final String lastFetched;
  final WeatherInfoModel weatherInfoModel;
  const HomeScreenUI({
    super.key,
    required this.lastFetched,
    required this.weatherInfoModel,
  });

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  final WeatherBloc weatherBloc = WeatherBloc();
  double _verticalPosition = 0.0;
  bool _isMovingUp = true;
  String greeting = "Good Morning";
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        // Update the vertical position based on the direction (up or down)
        _verticalPosition += _isMovingUp ? 0.8 : -0.8;
        // If the image reaches certain positions, change the direction
        if (_verticalPosition >= 6.0) {
          _isMovingUp = false;
        } else if (_verticalPosition <= -6.0) {
          _isMovingUp = true;
        }
        greeting = determineGreeting();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, kToolbarHeight, 40, 15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(30, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-30, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1.3),
              child: Container(
                height: 300,
                width: 600,
                decoration: const BoxDecoration(
                  color: Color(0xffffab40),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            widget.weatherInfoModel.areaName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "last fetched: ${DateFormat('h:mm a').format(DateTime.parse(widget.lastFetched))}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // BlocBuilder<WeatherBloc, WeatherState>(
                      //   bloc: weatherBloc,
                      //   builder: (context, state) {
                      //     if (state is WeatherLoadingState) {
                      //       return const SizedBox(
                      //         height: 23,
                      //         width: 23,
                      //         child: CircularProgressIndicator(
                      //           color: Colors.white,
                      //           strokeWidth: 3,
                      //         ),
                      //       );
                      //     } else if (state is WeatherSuccessState ||
                      //         state is WeatherInitial) {
                      //       return GestureDetector(
                      //         onTap: () {
                      //           weatherBloc.add(FetchWeatherEvent());
                      //         },
                      //         child: const Icon(
                      //           Icons.refresh,
                      //           color: Colors.white,
                      //           size: 27,
                      //         ),
                      //       );
                      //     } else if (state is WeatherFailureState) {
                      //       return Row(
                      //         children: [
                      //           const Text(
                      //             'failed ',
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 10),
                      //           ),
                      //           GestureDetector(
                      //             onTap: () {
                      //               weatherBloc.add(FetchWeatherEvent());
                      //             },
                      //             child: const Icon(
                      //               Icons.refresh,
                      //               color: Colors.white,
                      //               size: 27,
                      //             ),
                      //           ),
                      //         ],
                      //       );
                      //     } else {
                      //       return const SizedBox();
                      //     }
                      //   },
                      // ),
                      GestureDetector(
                        onTap: () {
                          weatherBloc.add(FetchWeatherEvent());
                        },
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 80),
                      curve: Curves.easeInOut,
                      child: Transform.translate(
                          offset: Offset(0, _verticalPosition),
                          child: Image.asset('assets/5.png'))),
                  Center(
                    child: Text(
                      "${widget.weatherInfoModel.temp?.round()}°C",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 55,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.weatherInfoModel.description ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      DateFormat('EEEE d, h:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/11.png',
                            scale: 8,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sunrise',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                DateFormat('h:mm a').format(
                                    widget.weatherInfoModel.sunraise ??
                                        DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/12.png',
                            scale: 8,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sunset',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                DateFormat('h:mm a').format(
                                    widget.weatherInfoModel.sunset ??
                                        DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/13.png',
                            scale: 8,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Temp Max',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "${widget.weatherInfoModel.maxTemp?.round()}°C",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/14.png',
                            scale: 8,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Temp Min',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "${widget.weatherInfoModel.minTemp!.round()}°C",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String determineGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }
}
