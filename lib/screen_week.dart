import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'func.dart';

class screen_week extends StatefulWidget {
  @override
  _screen_weekState createState() => _screen_weekState();
}

class _screen_weekState extends State<screen_week> {
  bool isDarkMode = false;
  TemperatureUnit selectedTemperatureUnit = TemperatureUnit.celsius;
  bool isCelsius = true; // Declare isCelsius here

  @override
  Widget build(BuildContext context) {
    String backgroundImage = isDarkMode
        ? 'https://i.pinimg.com/564x/fc/b9/43/fcb9430c73973cd55cf5494e882d872e.jpg'
        : 'https://i.pinimg.com/564x/c2/93/8e/c2938eb7ff7456c0c736441e22b322f1.jpg';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchWeekWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dayWeather = snapshot.data![index];
                            DateTime date = DateTime.now().add(Duration(days: index));
                            String dayOfWeek = getDayOfWeek(date.weekday);
                            String formattedDate = '${date.day} ${getMonth(date.month)}';

                            return Card(
                              elevation: 2.0,
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              color: isDarkMode ? Colors.white24 : null,
                              child: ListTile(
                                title: Text(
                                  '$dayOfWeek, $formattedDate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: isDarkMode ? Colors.blue[700] : Colors.cyan[300],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDayRow('Maksymalna temperatura: ', 'maxTemperature', dayWeather),
                                    _buildDayRow('Minimalna temperatura: ', 'minTemperature', dayWeather),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Wystąpił błąd: ${snapshot.error}'));
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 14.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _showTemperatureUnitSelectionMenu(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTemperatureUnitSelectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.blueGrey[700] : Colors.cyan,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isCelsius = true;
                    selectedTemperatureUnit = TemperatureUnit.celsius;
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
                    selectedTemperatureUnit = TemperatureUnit.fahrenheit;
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
        );
      },
    );
  }

  String getDayOfWeek(int weekday) {
    List<String> daysOfWeek = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];
    return daysOfWeek[weekday - 1];
  }

  String getMonth(int month) {
    List<String> months = [
      'stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca', 'lipca', 'sierpnia', 'września', 'października', 'listopada', 'grudnia'
    ];
    return months[month - 1];
  }

  Widget _buildDayRow(String rowText, String statName, Map<String, dynamic> dayWeather) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rowText,
            style: TextStyle(fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[600],),
          ),
          Text(
            _convertTemperature(dayWeather[statName]),
            style: TextStyle(fontSize: 16.0,
                color: isDarkMode ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _convertTemperature(double temperature) {
    if (selectedTemperatureUnit == TemperatureUnit.celsius) {
      return '$temperature °C';
    } else {
      // Convert Celsius to Fahrenheit
      double fahrenheit = (temperature * 9 / 5) + 32;
      return '$fahrenheit °F';
    }
  }
}

// Enum to represent temperature units
enum TemperatureUnit {
  celsius,
  fahrenheit,
}

