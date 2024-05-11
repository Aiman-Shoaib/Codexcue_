import 'package:flutter/material.dart';
import 'package:weather/weather_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      color: Colors.blue,
      home: WeatherPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
