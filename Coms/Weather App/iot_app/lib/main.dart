import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Clock',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontFamily: 'Orbitron',
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = true;
  late Timer timer;

  final List<Map<String, String>> locations = [
    {
      'name': 'Gussi | Puffy | Michi | Mira | Wings | Karby',
      'timezone': 'UTC +8',
      'loc': 'pht',
    },
    {'name': 'Nara Mai', 'timezone': 'UTC -3', 'loc': 'brt'},
    {'name': 'Ella', 'timezone': 'UTC +2', 'loc': 'cet'},
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  String formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  Map<String, int> getTime(String loc) {
    DateTime now = DateTime.now().toUtc();
    switch (loc) {
      case 'pht':
        now = now.add(const Duration(hours: 8));
        break;
      case 'brt':
        now = now.subtract(const Duration(hours: 3));
        break;
      case 'cet':
        now = now.add(const Duration(hours: 2));
        break;
    }
    int hours = now.hour;
    int minutes = now.minute;
    int seconds = now.second;
    String ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12 == 0 ? 12 : hours % 12;
    return {
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'ampm': ampm == 'AM' ? 0 : 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Container(
        color: isDarkMode
            ? const Color.fromARGB(255, 36, 41, 45)
            : const Color.fromARGB(255, 240, 248, 255),
        child: ListView(
          children: locations.map((location) {
            Map<String, int> time = getTime(location['loc']!);
            return Container(
              height: 220.0,
              constraints: const BoxConstraints(maxWidth: 560.0),
              decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color.fromARGB(255, 50, 56, 64)
                      : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Color(0x00000000),
                        offset: Offset(0, 5.0),
                        blurRadius: 10.0)
                  ]),
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    location['name']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '(${location['timezone']})',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            formatTime(time['hours']!),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const Text('Hrs'),
                        ],
                      ),
                      const Text(':'),
                      Column(
                        children: [
                          Text(
                            formatTime(time['minutes']!),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const Text('Min'),
                        ],
                      ),
                      const Text(':'),
                      Column(
                        children: [
                          Text(
                            formatTime(time['seconds']!),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const Text('Sec'),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time['ampm'] == 0 ? 'AM' : 'PM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
