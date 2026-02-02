import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';
import '../bottom_nav.dart';
import 'weather_card_element.dart';
import 'weather_forecast.dart';

class WeatherScreen extends StatefulWidget {
  final bool isTourist;
  WeatherScreen(this.isTourist);

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
          "temp": w.temperature?.celsius!.round(),
          "temp-high": w.tempMax?.celsius!.round(),
          "temp-low": w.tempMin?.celsius!.round(),
          "wind": w.windSpeed! * 3.6.round(),
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
          "temp": w.temperature?.celsius!.round(),
          "temp-high": w.tempMax?.celsius!.round(),
          "temp-low": w.tempMin?.celsius!.round(),
          "wind": w.windSpeed! * 3.6,
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
    // bottom navbar object
    BottomNav nav = BottomNav(widget.isTourist);

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Weather",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
        ),
        backgroundColor: Colors.blueAccent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(24),
            ),
            width: double.infinity,
            height: 40,
            child: Center(
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search any location in Sri Lanka",
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(140, 255, 255, 255),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      getCurrentWeatherByName(city);
                    },
                    icon: Icon(Icons.location_on_outlined, color: Colors.white),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    String formattedText =
                        text[0].toUpperCase() + text.substring(1).toLowerCase();
                    city = formattedText.trim();
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(81, 255, 255, 255),
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: currentWeather.isEmpty
                            ? Text("Last Update: --")
                            : Text("Last Update: ${currentWeather['time']}"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        getCurrentCityAndWeather();
                        _textController.text = "";
                      },
                      icon: Row(
                        children: [
                          Icon(Icons.refresh_outlined, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${currentLocation}",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${formattedDate}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          weatherImage,

                          Text(
                            currentWeather.isEmpty
                                ? "--\u00B0C"
                                : "${currentWeather['temp']}\u00B0C",
                            style: TextStyle(
                              fontSize: 50.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentWeather.isEmpty
                                ? "--"
                                : "${currentWeather['weather']}",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            currentWeather.isEmpty
                                ? "H: --\u00B0 L: --\u00B0"
                                : "H: ${currentWeather['temp-high']}\u00B0 L: ${currentWeather['temp-low']}\u00B0",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        children: [
                          // first row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Wind direction card
                              WeatherCardElement.card(
                                context,
                                Icons.explore_outlined,
                                "Wind Direction",
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
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Weather Forecast",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          forecast.isNotEmpty
                              ? WeatherForecast(forecast)
                              : Center(
                                  child: CircularProgressIndicator.adaptive(),
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
        ),
      ),
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
