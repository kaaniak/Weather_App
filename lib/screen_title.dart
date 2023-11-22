import 'package:flutter/material.dart';
import 'package:pogoda/screen_day.dart';
import 'package:pogoda/screen_week.dart';

void main() {
  runApp(screen_title());
}

class screen_title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: dd(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class dd extends StatefulWidget {
  @override
  _ddState createState() => _ddState();
}

class _ddState extends State<dd> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _barek();
  }

  void _barek() {
    Future.delayed(Duration(seconds: 1), () {
      final snackBar = SnackBar(
        content: Text(
          'Witaj, jak się masz?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.cyanAccent,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              isDarkMode
                  ? 'https://i.pinimg.com/564x/fc/b9/43/fcb9430c73973cd55cf5494e882d872e.jpg'
                  : 'https://i.pinimg.com/564x/c2/93/8e/c2938eb7ff7456c0c736441e22b322f1.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${DateTime.now().toIso8601String().substring(11, 16)}',
                style: TextStyle(
                  color: isDarkMode ? Colors.blueGrey!.withAlpha(200) : Colors.cyan[300]!.withAlpha(200),
                  fontWeight: FontWeight.bold,
                  fontSize: 64.0,
                ),
              ),
              SizedBox(height: 4),
              Text(
                poldata(),
                style: TextStyle(
                  color: isDarkMode ? Colors.blueGrey!.withAlpha(200) : Colors.cyan[300]!.withAlpha(200),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen_day()),
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
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Pogoda na dzisiaj',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen_week()),
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
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Pogoda na tydzień',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_on,
                    color: isDarkMode
                        ? Colors.blueGrey.withAlpha(200)
                        : Colors.cyan[300]!.withAlpha(200),
                    size: 16.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Słupsk',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.blueGrey.withAlpha(200)
                          : Colors.cyan[300]!.withAlpha(200),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
        isDarkMode ? Colors.blueGrey!.withAlpha(200) : Colors.cyanAccent[200]!.withAlpha(200),
        onPressed: () {
          _showSettingsMenu(context);
        },
        child: Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      drawer: lewybarek(),
    );
  }

  String poldata() {
    DateTime now = DateTime.now();
    String day = now.day.toString();
    String month = _mscpol(now.month);
    String year = now.year.toString();

    return '$day $month $year';
  }

  String _mscpol(int month) {
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

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          color: isDarkMode ? Colors.blueGrey : Colors.cyan,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.brightness_7),
                title: Text(
                  'Tryb jasny',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    isDarkMode = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_4),
                title: Text(
                  'Tryb ciemny',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    isDarkMode = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class lewybarek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Image.network(
              'https://www.ibexa.co/var/site/storage/images/2/0/6/7/47602-14-eng-GB/logo-Kaliop-2021-RGB%20(1).png',
              fit: BoxFit.contain,
            ),
          ),
          ListTile(
            title: Text('Autorzy:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          ListTile(
            title: Text('- Aleksander'),
          ),
          ListTile(
            title: Text('- Jakub'),
          ),
          ListTile(
            title: Text('- Kacper'),
          ),
          ListTile(
            title: Image.network(
              'https://www.icegif.com/wp-content/uploads/2022/10/icegif-373.gif',
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}