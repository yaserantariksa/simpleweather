import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Weather> fetchWeather() async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=-6.905977&lon=107.613144&appid={{APPID}}&units=metric'));
  if (response.statusCode == 200) {
    return Weather.formJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Weather {
  final String city;
  final double temp;
  final String description;
  final int humidity;
  final String currently;
  final double windSpeed;
  final String weatherIcon;

  const Weather(
      {required this.city,
      required this.temp,
      required this.description,
      required this.humidity,
      required this.currently,
      required this.windSpeed,
      required this.weatherIcon});

  factory Weather.formJson(Map<String, dynamic> jsonResult) {
    return Weather(
        city: jsonResult['name'],
        temp: jsonResult['main']['temp'],
        description: jsonResult['weather'][0]['description'],
        humidity: jsonResult['main']['humidity'],
        currently: jsonResult['weather'][0]['main'],
        windSpeed: jsonResult['wind']['speed'],
        weatherIcon: jsonResult['weather'][0]['icon']);
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // this is statelesswidget constructor
  const MyApp({super.key});

  // this is method
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Weather Flutter App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          snapshot.data!.city,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black54),
                        ),
                        Image.network(
                          'https://openweathermap.org/img/wn/${snapshot.data!.weatherIcon}@4x.png',
                        ),
                        Text(
                          "${snapshot.data!.temp}\u00B0 C",
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.sunny_snowing),
                              Text(
                                snapshot.data!.currently,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.thermostat_sharp),
                              Text(
                                "${snapshot.data!.temp}\u00B0 C",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.water_drop_outlined),
                              Text(
                                snapshot.data!.humidity.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.air),
                              Text(
                                snapshot.data!.windSpeed.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Sorry .. Can not load data'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
