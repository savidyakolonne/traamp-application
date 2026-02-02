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
          spacing: 8,
          children: [
            for (int i = 0; i < widget.forecast.length; i++)
              Container(
                width: 130,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(87, 255, 255, 255),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('EEEE, d').format(widget.forecast[i].date!),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(DateFormat('HH:mm').format(widget.forecast[i].date!)),
                    Image.network(
                      "http://openweathermap.org/img/wn/${widget.forecast[i].weatherIcon}@2x.png",
                      width: 60,
                      height: 60,
                    ),
                    Text(widget.forecast[i].weatherDescription!),
                    Text(
                      "${widget.forecast[i].temperature!.celsius!.round()}\u00B0C",
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

// class WeatherForecast {
//   static Widget forecastSection(List<Weather> forecast) {
//     return SizedBox(
//       width: double.infinity,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           spacing: 8,
//           children: [
//             for (int i = 0; i < forecast.length; i++)
//               Container(
//                 width: 130,
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(87, 255, 255, 255),
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       DateFormat('EEEE, d').format(forecast[i].date!),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Text(DateFormat('HH:mm').format(forecast[i].date!)),
//                     Image.network(
//                       "http://openweathermap.org/img/wn/${forecast[i].weatherIcon}@2x.png",
//                       width: 60,
//                       height: 60,
//                     ),
//                     Text(forecast[i].weatherDescription!),
//                     Text("${forecast[i].temperature!.celsius!.round()}\u00B0C"),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
