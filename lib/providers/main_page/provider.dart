import 'package:easy_weather/providers/main_page/model/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherNotifier extends ChangeNotifier {
  static final WeatherNotifier _singleton = WeatherNotifier._internal();

  factory WeatherNotifier() {
    return _singleton;
  }

  WeatherNotifier._internal();

  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;

  void initWeather(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _weatherData = WeatherData.fromRawJson(response.body);
        notifyListeners();
      } else {
        debugPrint('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Исключение при загрузке: $e');
    }
  }

  // Температура на текущий час
  int? getCurrentWeather() {
    final now = DateTime.now();
    final todayAtHour = _weatherData?.getTodayAtHour(now.hour);
    return todayAtHour?.temperature.toInt();
  }

  // Погода на конкретный час сегодня
  int? getWeatherAtHour(int hour) {
    return _weatherData?.getTodayAtHour(hour)?.temperature.toInt();
  }

  List<DailySummary>? getNextSixDaysForecast() {
    return _weatherData?.getNextSixDays();
  }
}
