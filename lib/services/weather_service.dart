import 'package:weather/weather.dart';

class WeatherService {
  static final String weatherKey = "84cba461d3a2e8ba8f560bb05742885e";
  static Future<Weather> getCurrentWeatherWithCoordinates(
    double lat,
    double long,
  ) async {
    final WeatherFactory wf = WeatherFactory(weatherKey);
    Weather w = await wf.currentWeatherByLocation(lat, long);
    return w;
  }

  static Future<Weather> getCurrentWeatherWithCityName(String cityName) async {
    final WeatherFactory wf = WeatherFactory(weatherKey);
    Weather w = await wf.currentWeatherByCityName(cityName);
    return w;
  }

  static Future<List<Weather>> fiveDayForecastWithCityName(
    String cityName,
  ) async {
    final WeatherFactory wf = WeatherFactory(weatherKey);
    List<Weather> forecast = await wf.fiveDayForecastByCityName(cityName);
    return forecast;
  }

  static Future<List<Weather>> fiveDayForecastWithCoordinates(
    double lat,
    double long,
  ) async {
    final WeatherFactory wf = WeatherFactory(weatherKey);
    List<Weather> forecast = await wf.fiveDayForecastByLocation(lat, long);
    return forecast;
  }
}
