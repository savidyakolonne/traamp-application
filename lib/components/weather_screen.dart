import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'bottom_nav.dart';

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
          "wind": w.windSpeed,
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
      });
      print(currentWeather);
    } catch (e) {
      print(e.toString());
    }
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
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.all(16.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: const Color.fromARGB(81, 255, 255, 255),
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text("Last Update: ${currentWeather['time']}"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        getCurrentCityAndWeather();
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
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Column(
                  children: [
                    weatherImage,
                    //Icon(Ima, color: Colors.white, size: 70),
                    Text(
                      "${currentWeather['temp']} \u00B0C",
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${currentWeather['weather']}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "H: ${currentWeather['temp-high']}\u00B0 L: ${currentWeather['temp-low']}\u00B0",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // first row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // wind card
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(87, 255, 255, 255),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(Icons.air, color: Colors.white, size: 35),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wind",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "${currentWeather['wind']} mph",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Humidity card
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(87, 255, 255, 255),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.water_drop_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Humidity",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${currentWeather['humidity']}%",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // second row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Wind direction card
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(87, 255, 255, 255),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.explore_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wind Direction",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "${currentWeather['wind-direction']}\u00B0",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Pressure card
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(87, 255, 255, 255),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.speed_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pressure",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${currentWeather['pressure']} hPa",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
