import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

class WeatherForecast extends StatefulWidget {
  final List<Weather> forecast;
  const WeatherForecast(this.forecast, {super.key});

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 20,
          children: [
            for (int i = 0; i < widget.forecast.length; i++)
              Container(
                width: 110,
                height: 173,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(54, 0, 0, 0),
                      blurRadius: 5,
                    ),
                  ],
                  color: i == 0
                      ? const Color.fromARGB(255, 125, 212, 33)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    i == 0
                        ? Text(
                            "NOW",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            DateFormat(
                              'EEEE, d',
                            ).format(widget.forecast[i].date!),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: i != 0
                                  ? const Color.fromARGB(255, 112, 123, 138)
                                  : Colors.white,
                            ),
                          ),
                    if (i != 0)
                      Text(
                        DateFormat('HH:mm').format(widget.forecast[i].date!),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 112, 123, 138),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    Image.network(
                      "http://openweathermap.org/img/wn/${widget.forecast[i].weatherIcon}@2x.png",
                      width: 60,
                      height: 60,
                    ),
                    if (i == 0) SizedBox(height: 14),
                    Text(
                      "${widget.forecast[i].temperature!.celsius!.round()}\u00B0C",
                      style: TextStyle(
                        color: i == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
