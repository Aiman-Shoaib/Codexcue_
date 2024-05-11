import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String _apiKey = "c3e6a4d24e0a776badd946674c7b33e3"; //api key
  final String _apiUrl =
      "http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}";

  final _cityController = TextEditingController();
  var _temperature;
  var _weatherDescription;
  bool _isLoading = false;
  bool _hasError = false;
  var _icon;
  var _humidity;
  var _windSpeed;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _temperature = null; // Clear previous data
      _weatherDescription = null; // Clear previous data
      _icon = null;
      _humidity = null;
      _windSpeed = null;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl
          .replaceAll("{city}", cityName)
          .replaceAll("{api_key}", _apiKey)));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          double tempKelvin = data['main']['temp'];
          _temperature = tempKelvin - 273.15;
          _weatherDescription = data['weather'][0]['description'];
          _icon = data['weather'][0]['icon'];
          _humidity = data['main']['humidity'];
          _windSpeed = data['wind']['speed'];
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 8.0,
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter City Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _fetchWeather(_cityController.text);
                  },
                  child: Text('Get Weather',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : _hasError
                        ? const Text(
                            'Failed to load weather data',
                            style: TextStyle(color: Colors.red),
                          )
                        : _temperature != null && _weatherDescription != null
                            ? Column(
                                children: [
                                  Text(
                                    'Temperature: ${_temperature.toStringAsFixed(2)}°C',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Condition: $_weatherDescription',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  const SizedBox(height: 20),
                                  _icon != null
                                      ? Image.network(
                                          'http://openweathermap.org/img/w/$_icon.png',
                                          width: 100,
                                          height: 100,
                                        )
                                      : Container(),
                                  const SizedBox(height: 20),
                                  _humidity != null
                                      ? Text(
                                          'Humidity: $_humidity%',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        )
                                      : Container(),
                                  const SizedBox(height: 20),
                                  _windSpeed != null
                                      ? Text(
                                          'Wind Speed: $_windSpeed m/s',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        )
                                      : Container(),
                                ],
                              )
                            : Container(), // Empty container if no data
              ],
            ),
          ),
        ),
      ),
    );
  }
}
