import 'dart:convert';

/// Расшифровка кодов погоды WMO (по желанию)
String weatherDescription(int code) {
  const Map<int, String> descriptions = {
    0: 'Ясно',
    1: 'Преимущественно ясно',
    2: 'Переменная облачность',
    3: 'Пасмурно',
    45: 'Туман',
    48: 'Туман с инеем',
    51: 'Лёгкая морось',
    53: 'Умеренная морось',
    55: 'Сильная морось',
    56: 'Лёгкая ледяная морось',
    57: 'Сильная ледяная морось',
    61: 'Небольшой дождь',
    63: 'Умеренный дождь',
    65: 'Сильный дождь',
    66: 'Лёгкий ледяной дождь',
    67: 'Сильный ледяной дождь',
    71: 'Небольшой снег',
    73: 'Умеренный снег',
    75: 'Сильный снег',
    77: 'Снежные зёрна',
    80: 'Ливневый дождь',
    81: 'Умеренные ливни',
    82: 'Сильные ливни',
    85: 'Небольшой снегопад',
    86: 'Сильный снегопад',
    95: 'Гроза',
    96: 'Гроза с небольшим градом',
    99: 'Гроза с сильным градом',
  };
  return descriptions[code] ?? 'Неизвестный код';
}

/// Возвращает путь к SVG-иконке погоды из набора Weather Icons.
/// [wmoCode] – код погоды WMO (0, 1, 2, 3, 45, 48, 51 ... 99).
/// [isDay] – true для дневного варианта, false для ночного.
String weatherIconAsset(int wmoCode, {bool isDay = true}) {
  // Имена файлов БЕЗ расширения .svg – оно добавляется в конце
  const Map<int, String> dayIcons = {
    0: 'wi-day-sunny', // Ясно
    1: 'wi-day-sunny-overcast', // Преимущественно ясно
    2: 'wi-day-cloudy', // Переменная облачность
    3: 'wi-cloudy', // Пасмурно (без деления день/ночь)
    45: 'wi-day-fog', // Туман
    48: 'wi-fog', // Туман с инеем (нет отдельной иконки)
    51: 'wi-day-sprinkle', // Лёгкая морось
    53: 'wi-day-sprinkle', // Умеренная морось
    55: 'wi-day-sprinkle', // Сильная морось
    56: 'wi-day-rain-mix', // Лёгкая ледяная морось
    57: 'wi-day-rain-mix', // Сильная ледяная морось
    61: 'wi-day-rain', // Небольшой дождь
    63: 'wi-day-rain', // Умеренный дождь
    65: 'wi-day-rain', // Сильный дождь
    66: 'wi-day-rain-mix', // Лёгкий ледяной дождь
    67: 'wi-day-rain-mix', // Сильный ледяной дождь
    71: 'wi-day-snow', // Небольшой снег
    73: 'wi-day-snow', // Умеренный снег
    75: 'wi-day-snow', // Сильный снег
    77: 'wi-day-sleet', // Снежные зёрна
    80: 'wi-day-showers', // Ливневый дождь
    81: 'wi-day-showers', // Умеренные ливни
    82: 'wi-day-showers', // Сильные ливни
    85: 'wi-day-snow-wind', // Небольшой снегопад
    86: 'wi-day-snow-wind', // Сильный снегопад
    95: 'wi-day-thunderstorm', // Гроза
    96: 'wi-day-hail', // Гроза с небольшим градом
    99: 'wi-day-hail', // Гроза с сильным градом
  };

  const Map<int, String> nightIcons = {
    0: 'wi-night-clear',
    1: 'wi-night-partly-cloudy',
    2: 'wi-night-cloudy',
    3: 'wi-cloudy', // Пасмурно – без изменений
    45: 'wi-night-fog',
    48: 'wi-fog',
    51: 'wi-night-sprinkle',
    53: 'wi-night-sprinkle',
    55: 'wi-night-sprinkle',
    56: 'wi-night-rain-mix',
    57: 'wi-night-rain-mix',
    61: 'wi-night-rain',
    63: 'wi-night-rain',
    65: 'wi-night-rain',
    66: 'wi-night-rain-mix',
    67: 'wi-night-rain-mix',
    71: 'wi-night-snow',
    73: 'wi-night-snow',
    75: 'wi-night-snow',
    77: 'wi-night-sleet',
    80: 'wi-night-showers',
    81: 'wi-night-showers',
    82: 'wi-night-showers',
    85: 'wi-night-snow-wind',
    86: 'wi-night-snow-wind',
    95: 'wi-night-thunderstorm',
    96: 'wi-night-hail',
    99: 'wi-night-hail',
  };

  final iconName = (isDay ? dayIcons[wmoCode] : nightIcons[wmoCode]) ?? 'wi-na';
  return 'lib/assets/icons/$iconName.svg';
}

class CurrentWeather {
  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: DateTime.parse(json['time']),
      temperature: (json['temperature_2m'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
    );
  }

  final double temperature;
  final DateTime time;
  final int weatherCode;
  final double windSpeed;
}

class HourlyData {
  HourlyData({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.rain,
  });

  final double rain;
  final double temperature;
  final DateTime time;
  final int weatherCode;
}

class DailyData {
  DailyData({
    required this.date,
    required this.weatherCode,
    required this.meanTemperature,
  });

  final DateTime date;
  final double meanTemperature;
  final int weatherCode;
}

class DailySummary {
  DailySummary({
    required this.date,
    required this.weatherCode,
    required this.meanTemperature,
    required this.totalRain,
  });

  final DateTime date;
  final double meanTemperature;
  final double totalRain;
  final int weatherCode;
}

class WeatherData {
  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // current
    final currentJson = json['current'] as Map<String, dynamic>;

    // hourly
    final hourlyJson = json['hourly'] as Map<String, dynamic>;
    final List<dynamic> times = hourlyJson['time'];
    final List<dynamic> temps = hourlyJson['temperature_2m'];
    final List<dynamic> weatherCodes = hourlyJson['weather_code'];
    final List<dynamic> rains = hourlyJson['rain'];

    final List<HourlyData> hourlyList = [];
    for (int i = 0; i < times.length; i++) {
      hourlyList.add(
        HourlyData(
          time: DateTime.parse(times[i]),
          temperature: (temps[i] as num).toDouble(),
          weatherCode: (weatherCodes[i] as num).toInt(),
          rain: (rains[i] as num).toDouble(),
        ),
      );
    }

    // daily
    final dailyJson = json['daily'] as Map<String, dynamic>;
    final List<dynamic> dailyTimes = dailyJson['time'];
    final List<dynamic> dailyWeatherCodes = dailyJson['weather_code'];
    final List<dynamic> dailyMeanTemps = dailyJson['temperature_2m_mean'];

    final List<DailyData> dailyList = [];
    for (int i = 0; i < dailyTimes.length; i++) {
      dailyList.add(
        DailyData(
          date: DateTime.parse(dailyTimes[i]),
          weatherCode: (dailyWeatherCodes[i] as num).toInt(),
          meanTemperature: (dailyMeanTemps[i] as num).toDouble(),
        ),
      );
    }

    return WeatherData(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'],
      current: CurrentWeather.fromJson(currentJson),
      hourly: hourlyList,
      daily: dailyList,
    );
  }

  /// Быстрый конструктор из сырого JSON-строки (как старая модель)
  factory WeatherData.fromRawJson(String jsonString) {
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return WeatherData.fromJson(jsonMap);
  }

  final CurrentWeather current;
  final List<DailyData> daily;
  final List<HourlyData> hourly;
  final double latitude;
  final double longitude;
  final String timezone;

  /// Погода на текущий час
  HourlyData? getTodayAtHour(int hour) {
    final refDate = DateTime(
      current.time.year,
      current.time.month,
      current.time.day,
    );
    return hourly.firstWhereOrNull(
      (h) =>
          h.time.year == refDate.year &&
          h.time.month == refDate.month &&
          h.time.day == refDate.day &&
          h.time.hour == hour,
    );
  }

  /// Прогноз на следующие 6 дней (после дня текущих данных)
  List<DailySummary> getNextSixDays() {
    final today = DateTime(
      current.time.year,
      current.time.month,
      current.time.day,
    );

    final nextDays = daily.where((d) {
      final dDate = DateTime(d.date.year, d.date.month, d.date.day);
      return dDate.isAfter(today);
    }).toList();

    // Суммируем осадки по дням из почасовых данных
    final Map<String, double> rainByDate = {};
    for (final h in hourly) {
      final key =
          '${h.time.year}-${h.time.month.toString().padLeft(2, '0')}-${h.time.day.toString().padLeft(2, '0')}';
      rainByDate[key] = (rainByDate[key] ?? 0.0) + h.rain;
    }

    return nextDays.map((d) {
      final key =
          '${d.date.year}-${d.date.month.toString().padLeft(2, '0')}-${d.date.day.toString().padLeft(2, '0')}';
      return DailySummary(
        date: d.date,
        weatherCode: d.weatherCode,
        meanTemperature: d.meanTemperature,
        totalRain: rainByDate[key] ?? 0.0,
      );
    }).toList();
  }
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
