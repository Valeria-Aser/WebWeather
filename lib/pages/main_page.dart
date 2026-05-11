import 'package:easy_weather/providers/main_page/model/weather_model.dart';
import 'package:easy_weather/providers/main_page/provider.dart';
import 'package:easy_weather/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentTempereture = ValueNotifier<double?>(null);
  WeatherNotifier weatherNotifier = WeatherNotifier();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    //? Брать данные с устройства
    final lantitude = 53.23;
    final longitude = 59.02;

    var url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lantitude&longitude=$longitude&daily=weather_code,temperature_2m_mean&hourly=temperature_2m,weather_code,rain&current=temperature_2m,weather_code,wind_speed_10m&timezone=auto&past_days=0&forecast_days=7";
    weatherNotifier.initWeather(url);
  }

  Widget isModileView() {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: []),
        actions: const [],
        backgroundColor: Style.bgColor,
        surfaceTintColor: Style.surfaceTintColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Style.bgColor),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: weatherNotifier,
            builder: (context, widget) {
              final currentTemp = weatherNotifier.getCurrentWeather();
              final forecast = weatherNotifier.getNextSixDaysForecast();
              return weatherNotifier.weatherData == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.amber,
                          color: Colors.black26,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "$currentTemp°",
                              style: TextStyle(
                                fontSize: 80,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: .5,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 600,
                                    childAspectRatio: 16 / 9,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                              itemCount: 6,
                              itemBuilder: (BuildContext context, index) {
                                var pathImg = weatherIconAsset(
                                  forecast![index].weatherCode,
                                  isDay: true,
                                );

                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: (forecast ?? []).isEmpty
                                      ? Text("Empty")
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  forecast[index].date
                                                      .toString()
                                                      .split(' ')
                                                      .first,
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  weatherDescription(
                                                    forecast[index].weatherCode,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 250,
                                                      child: SvgPicture.asset(
                                                        pathImg,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${forecast[index].meanTemperature}°",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isModileView();
  }
}
