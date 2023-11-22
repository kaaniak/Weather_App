import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pogoda/screen_charts.dart';

class screen_day extends StatefulWidget {
  @override
  _screen_dayState createState() => _screen_dayState();
}

class _screen_dayState extends State<screen_day> {
  Map<String, dynamic> weatherData = {};
  bool isDarkMode = false;
  bool isCelsius = true; // Dodana zmienna do śledzenia wyboru jednostki temperatury

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final Map<String, dynamic> data = await getWeatherData(
          'https://api.open-meteo.com/v1/forecast?latitude=54.46&longitude=17.03&hourly=temperature_2m,relative_humidity_2m,rain,cloud_cover,wind_speed_10m&timezone=Europe%2FBerlin');
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch weather data. Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            isDarkMode
                ? 'https://i.pinimg.com/564x/fc/b9/43/fcb9430c73973cd55cf5494e882d872e.jpg'
                : 'https://i.pinimg.com/564x/c2/93/8e/c2938eb7ff7456c0c736441e22b322f1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 110.0, 16.0, 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pogoda na dziś',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.blueGrey : Colors.cyan[300],),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${DateTime.now().day} ${_mscPol(DateTime.now().month)} ${_mscPol(DateTime.now().year)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${DateTime.now().hour.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 64.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            fontSize: 64.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 64.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('')),
                        DataColumn(label: Text(''), numeric: true,),
                      ],
                      rows: [
                        _buildDataRow('Temperatura', '${_formatTemperature(weatherData['temperature'])}'),
                        _buildDataRow('Wilgotność', '${weatherData['humidity']}%'),
                        _buildDataRow('Opady', '${weatherData['rain']} mm'),
                        _buildDataRow('Zachmurzenie', '${weatherData['cloud_cover']}%'),
                        _buildDataRow('Prędkość wiatru', '${weatherData['wind_speed']} m/s'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => screen_charts()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isDarkMode
                            ? Colors.blueGrey!.withAlpha(200)
                            : Colors.cyan[300]!.withAlpha(200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 5.0,
                      ),
                      child: Text('Szczegółowe dane',
                        style: TextStyle(
                          color: Colors.white,
                        ),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),
          Positioned(
            bottom: 14.0,
            right: 10.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 14.0,
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _showBottomMenu(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 70.0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.blueGrey[700] : Colors.cyan,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCelsius = true;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isCelsius ? Colors.indigo[600] : Colors.black12,
                  ),
                  child: Text(
                    '°C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCelsius = false;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isCelsius ? Colors.black12 : Colors.indigo[600],
                  ),
                  child: Text(
                    '°F',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DataRow _buildDataRow(String rowText, String? statValue) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            rowText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
          ),
        ),
        DataCell(
          Text(
            statValue ?? 'N/A',
            style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.blueGrey[700] : Colors.cyan[300], fontSize: 22),
          ),
        ),
      ],
    );
  }

  String _mscPol(int month) {
    switch (month) {
      case 1:
        return 'stycznia';
      case 2:
        return 'lutego';
      case 3:
        return 'marca';
      case 4:
        return 'kwietnia';
      case 5:
        return 'maja';
      case 6:
        return 'czerwca';
      case 7:
        return 'lipca';
      case 8:
        return 'sierpnia';
      case 9:
        return 'września';
      case 10:
        return 'października';
      case 11:
        return 'listopada';
      case 12:
        return 'grudnia';
      default:
        return '';
    }
  }

  String _formatTemperature(String? temperature) {
    if (temperature == null) {
      return 'N/A';
    }

    if (isCelsius) {
      return '$temperature°C';
    } else {
      double fahrenheit = (double.parse(temperature) * 9 / 5) + 32;
      return '$fahrenheit°F';
    }
  }

  Future<Map<String, dynamic>> getWeatherData(final url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return getCurrentWeather(decodedData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Map<String, dynamic> getCurrentWeather(Map<String, dynamic> weatherData) {
    DateTime now = DateTime.now();
    String formattedNow = now.toIso8601String().substring(0, 14) + "00";
    int Mins = DateTime.now().minute;
    List<String> timeList = List<String>.from(weatherData['hourly']['time']);
    List<double> temperatureList =
    List<double>.from(weatherData['hourly']['temperature_2m']);
    List<int> humidityList =
    List<int>.from(weatherData['hourly']['relative_humidity_2m']);
    List<double> rainList = List<double>.from(weatherData['hourly']['rain']);
    List<int> cloudCoverList =
    List<int>.from(weatherData['hourly']['cloud_cover']);
    List<double> windSpeedList =
    List<double>.from(weatherData['hourly']['wind_speed_10m']);

    int currentIndex = timeList.indexOf(formattedNow);
    if (currentIndex != -1) {
      return {
        'time': timeList[currentIndex],
        'temperature': (((temperatureList[currentIndex] * (60 - Mins)) +
            (temperatureList[currentIndex + 1] * (Mins))) /
            60)
            .toStringAsFixed(1),
        'humidity': (((humidityList[currentIndex] * (60 - Mins)) +
            (humidityList[currentIndex + 1] * (Mins))) /
            60)
            .toStringAsFixed(2),
        'rain': (((rainList[currentIndex] * (60 - Mins)) +
            (rainList[currentIndex + 1] * (Mins))) /
            60)
            .toStringAsFixed(2),
        'cloud_cover': (((cloudCoverList[currentIndex] * (60 - Mins)) +
            (cloudCoverList[currentIndex + 1] * (Mins))) /
            60)
            .toStringAsFixed(2),
        'wind_speed': (((windSpeedList[currentIndex] * (60 - Mins)) +
            (windSpeedList[currentIndex + 1] * (Mins))) /
            60)
            .toStringAsFixed(2),
      };
    } else {
      return {};
    }
  }
}