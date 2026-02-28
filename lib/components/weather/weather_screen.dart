import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import '../../screens/guide/guide_dashboard.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';
import 'weather_card_element.dart';
import 'weather_forecast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String currentLocation = "Unknown location";
  String formattedDate = DateFormat('EEEE,MMMM d').format(DateTime.now());
  Map<String, dynamic> currentWeather = {};
  Widget weatherImage = CircularProgressIndicator.adaptive();
  final TextEditingController _textController = TextEditingController();
  String city = "";
  List<Weather> forecast = [];

  // get current location via GPS
  Future<void> getCurrentCityAndWeather() async {
    try {
      // Get current position
      final position = await LocationService.getCurrentPosition();

      final placemark = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemark.isNotEmpty ? placemark.first : null;

      setState(() {
        currentLocation = (place?.locality?.isNotEmpty == true
            ? place!.locality!
            : "Unknown");
      });
      getCurrentWeather(position.latitude, position.longitude);
    } catch (e) {
      print("Error: $e");
      setState(() {
        currentLocation = "Location unavailable";
      });
    }
  }

  // get current weather
  void getCurrentWeather(double lat, double long) async {
    try {
      Weather w = await WeatherService.getCurrentWeatherWithCoordinates(
        lat,
        long,
      );
      setState(() {
        currentWeather = {
          "weather": w.weatherDescription,
          "temp": (w.temperature?.celsius)!.round(),
          "temp-high": (w.tempMax?.celsius)!.round(),
          "temp-low": (w.tempMin?.celsius)!.round(),
          "wind": (w.windSpeed! * 3.6).round(),
          "humidity": w.humidity,
          "pressure": w.pressure,
          "country": w.country,
          "icon": w.weatherIcon,
          "wind-direction": w.windDegree,
          "lat": w.latitude,
          "long": w.longitude,
          "time": w.date,
        };
        weatherImage = Image.network(
          "http://openweathermap.org/img/wn/${currentWeather['icon']}@2x.png",
          width: 100,
          height: 100,
        );
        getWeatherForecastWithCoordinates(lat, long);
      });
      print(currentWeather);
    } catch (e) {
      print(e.toString());
    }
  }

  void getCurrentWeatherByName(String city) async {
    try {
      Weather w = await WeatherService.getCurrentWeatherWithCityName(city);
      setState(() {
        currentWeather = {
          "weather": w.weatherDescription,
          "temp": (w.temperature?.celsius)!.round(),
          "temp-high": (w.tempMax?.celsius)!.round(),
          "temp-low": (w.tempMin?.celsius)!.round(),
          "wind": (w.windSpeed! * 3.6).round(),
          "humidity": w.humidity,
          "pressure": w.pressure,
          "country": w.country,
          "icon": w.weatherIcon,
          "wind-direction": w.windDegree,
          "lat": w.latitude,
          "long": w.longitude,
          "time": w.date,
        };
        currentLocation = city;
        weatherImage = Image.network(
          "http://openweathermap.org/img/wn/${currentWeather['icon']}@2x.png",
          width: 100,
          height: 100,
        );
        _textController.text = "";
        getWeatherForecastWithCity(city);
      });
      print(currentWeather);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Given name of the city may incorrect!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(116, 0, 0, 0),
        ),
      );
    }
  }

  Future<void> getWeatherForecastWithCoordinates(
    double lat,
    double long,
  ) async {
    try {
      final result = await WeatherService.fiveDayForecastWithCoordinates(
        lat,
        long,
      );
      print(result.toString());
      setState(() {
        forecast = result;
      });
    } catch (e) {
      print(e.toString());
    }
    print(forecast.toString());
  }

  Future<void> getWeatherForecastWithCity(String city) async {
    try {
      final result = await WeatherService.fiveDayForecastWithCityName(city);
      print(result.toString());
      setState(() {
        forecast = result;
      });
    } catch (e) {
      print(e.toString());
    }
    print(forecast.toString());
  }

  @override
  void initState() {
    super.initState();
    getCurrentCityAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, GuideDashboard());
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Stay Prepared",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getCurrentCityAndWeather,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                // search bar section
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(61, 0, 0, 0),
                        blurRadius: 10,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: double.infinity,
                  height: 60,
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search any location in Sri Lanka",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 100, 116, 139),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            getCurrentWeatherByName(city);
                          },
                          icon: Icon(
                            Icons.location_on_outlined,
                            color: const Color.fromARGB(255, 100, 116, 139),
                            size: 28,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          String formattedText =
                              text[0].toUpperCase() +
                              text.substring(1).toLowerCase();
                          city = formattedText.trim();
                        });
                      },
                    ),
                  ),
                ),

                // Weather info section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // last update
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: currentWeather.isEmpty
                                  ? Text("Last Update: --")
                                  : Text(
                                      "Last Update: ${currentWeather['time']}",
                                    ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      // image
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromARGB(255, 125, 212, 33),
                        ),
                        child: Center(child: weatherImage),
                      ),

                      SizedBox(height: 20),

                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // location
                            Column(
                              children: [
                                Text(
                                  currentLocation,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // condition
                            Text(
                              currentWeather.isEmpty
                                  ? "--"
                                  : "${currentWeather['weather']}",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: const Color.fromARGB(255, 100, 116, 139),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // temperature
                            Column(
                              children: [
                                Text(
                                  currentWeather.isEmpty
                                      ? "--\u00B0C"
                                      : "${currentWeather['temp']}\u00B0C",
                                  style: TextStyle(
                                    fontSize: 72.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // high - low temperature
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 16,
                                  children: [
                                    // high
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          size: 20,
                                          color: const Color.fromARGB(
                                            255,
                                            100,
                                            116,
                                            139,
                                          ),
                                        ),
                                        Text(
                                          currentWeather.isEmpty
                                              ? "H: --\u00B0"
                                              : "H: ${currentWeather['temp-high']}\u00B0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: const Color.fromARGB(
                                              255,
                                              100,
                                              116,
                                              139,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // low
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          size: 20,
                                          color: const Color.fromARGB(
                                            255,
                                            100,
                                            116,
                                            139,
                                          ),
                                        ),
                                        Text(
                                          currentWeather.isEmpty
                                              ? "L: --\u00B0"
                                              : "L: ${currentWeather['temp-low']}\u00B0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: const Color.fromARGB(
                                              255,
                                              100,
                                              116,
                                              139,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                            Column(
                              children: [
                                // first row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // wind card
                                    WeatherCardElement.card(
                                      context,
                                      Icons.air,
                                      "Wind",
                                      currentWeather.isEmpty
                                          ? "--"
                                          : currentWeather['wind'],
                                      "km/h",
                                    ),
                                    // Humidity card
                                    WeatherCardElement.card(
                                      context,
                                      Icons.water_drop_outlined,
                                      "Humidity",
                                      currentWeather.isEmpty
                                          ? "--"
                                          : currentWeather['humidity'],
                                      "%",
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                // second row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Wind direction card
                                    WeatherCardElement.card(
                                      context,
                                      Icons.explore_outlined,
                                      "Direction",
                                      currentWeather.isEmpty
                                          ? "--"
                                          : currentWeather['wind-direction'],
                                      "\u00B0",
                                    ),
                                    // Pressure card
                                    WeatherCardElement.card(
                                      context,
                                      Icons.speed_outlined,
                                      "Pressure",
                                      currentWeather.isEmpty
                                          ? "--"
                                          : currentWeather['pressure'],
                                      "hPa",
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Weather Forecast",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      "Next 7 Days",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(
                                          255,
                                          125,
                                          212,
                                          33,
                                        ),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                forecast.isNotEmpty
                                    ? WeatherForecast(forecast)
                                    : Center(
                                        child:
                                            CircularProgressIndicator.adaptive(),
                                      ),

                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
