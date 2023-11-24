import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWeatherJson(final url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

List<Map<String, dynamic>> getCurrentWeather(Map<String, dynamic> weatherData) {
  DateTime now = DateTime.now();
  String formattedNow = now.toIso8601String().substring(0, 14)+"00";
  int Mins = DateTime.now().minute;
  List<String> timeList = List<String>.from(weatherData['hourly']['time']);
  List<double> temperatureList = List<double>.from(weatherData['hourly']['temperature_2m']);
  List<int> humidityList = List<int>.from(weatherData['hourly']['relative_humidity_2m']);
  List<double> rainList = List<double>.from(weatherData['hourly']['rain']);
  List<int> cloudCoverList = List<int>.from(weatherData['hourly']['cloud_cover']);
  List<double> windSpeedList = List<double>.from(weatherData['hourly']['wind_speed_10m']);

  int currentIndex = timeList.indexOf(formattedNow);
  if (currentIndex != -1) {
    return [
      {
        'time': timeList[currentIndex],
        'temperature': (((temperatureList[currentIndex]*(60-Mins))+(temperatureList[currentIndex+1]*(Mins)))/60).toStringAsFixed(1),
        'humidity': (((humidityList[currentIndex]*(60-Mins))+(humidityList[currentIndex+1]*(Mins)))/60).toStringAsFixed(2),
        'rain': (((rainList[currentIndex]*(60-Mins))+(rainList[currentIndex+1]*(Mins)))/60).toStringAsFixed(2),
        'cloudCover': (((cloudCoverList[currentIndex]*(60-Mins))+(cloudCoverList[currentIndex+1]*(Mins)))/60).toStringAsFixed(2),
        'windSpeed': (((windSpeedList[currentIndex]*(60-Mins))+(windSpeedList[currentIndex+1]*(Mins)))/60).toStringAsFixed(2),
      },
    ];
  } else {
    return [];
  }
}
List<Map<String, dynamic>> getWeekWeather(Map<String, dynamic> weatherData) {
  List<String> timeList = List<String>.from(weatherData['daily']['time']);
  List<double> minTemperatureList = List<double>.from(weatherData['daily']['temperature_2m_min']);
  List<double> maxTemperatureList = List<double>.from(weatherData['daily']['temperature_2m_max']);

  List<Map<String, dynamic>> weekWeather = [];

  for (int i = 0; i < timeList.length; i++) {
    Map<String, dynamic> dayWeather = {
      'time': timeList[i],
      'minTemperature': minTemperatureList[i],
      'maxTemperature': maxTemperatureList[i],
    };
    weekWeather.add(dayWeather);
  }

  return weekWeather;
}

Future<List<Map<String, dynamic>>> fetchWeekWeather() async {
  try {
    Map<String, dynamic> weatherData = await getWeatherJson(
        'https://api.open-meteo.com/v1/forecast?latitude=54.46&longitude=17.03&daily=temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin');
    List<Map<String, dynamic>> weekWeather = getWeekWeather(weatherData);
    return weekWeather;
  } catch (e) {
    throw Exception('Failed to fetch week weather: $e');
  }
}

Widget _buildDayRow(String rowText, String statName, List<Map<String, dynamic>> currentWeather){
  return Row(
    children: [
      Text(rowText),
      Text(currentWeather[0][statName])
    ],
  );
}

/* ALTERNATYWny SKRYPT KTÓRE TEŻ DZIAŁAJĄ
Widget _buildWeekRow(int dayNumber, List<Map<String, dynamic>> currentWeather){
  return Row(
    children: [
      Text((DateTime.now().day+dayNumber).toString()),
      Text(currentWeather[0]['minTemperature'][dayNumber]),
      Text(currentWeather[0]['maxTemperature'][dayNumber]),
    ],
  );
} */