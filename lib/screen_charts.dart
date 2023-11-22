import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'func.dart';


void main() {
  runApp(screen_charts());
}

class screen_charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: wykresy(),
    );
  }
}

class wykresy extends StatefulWidget {
  @override
  _wykresyState createState() => _wykresyState();
}

class _wykresyState extends State<wykresy> {
  late List<Map<String, dynamic>> currentWeather;

  @override
  void initState() {
    super.initState();
    // Fetch the current weather data
    fetchCurrentWeather();
  }

  Future<void> fetchCurrentWeather() async {
    try {
      // Use your API endpoint for current weather
      Map<String, dynamic> weatherData = await getWeatherJson(
          'https://api.open-meteo.com/v1/forecast?latitude=54.46&longitude=17.03&hourly=temperature_2m,relative_humidity_2m,rain,cloud_cover,wind_speed_10m&timezone=Europe%2FBerlin');

      setState(() {
        currentWeather = getCurrentWeather(weatherData);
      });
    } catch (e) {
      print('Error fetching current weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Chart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the chart
            currentWeather != null
                ? WeatherChart(currentWeather: currentWeather)
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class WeatherChart extends StatelessWidget {
  final List<Map<String, dynamic>> currentWeather;

  WeatherChart({required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // Set up your chart data here based on the currentWeather list
        // Refer to fl_chart documentation for customization options
        // https://pub.dev/packages/fl_chart
      ),
    );
  }
}


