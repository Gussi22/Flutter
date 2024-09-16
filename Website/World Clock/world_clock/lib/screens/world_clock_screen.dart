import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:world_clock/models/time_zone.dart';
import 'package:world_clock/widgets/time_zone_card.dart';

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({super.key});
  @override
  WorldClockScreenState createState() => WorldClockScreenState();
}

class WorldClockScreenState extends State<WorldClockScreen> {
  List<dynamic> _timeZones = [];
  TimeZone? _selectedTimeZone;

  @override
  void initState() {
    super.initState();
    _loadTimeZones();
    _startTimer();
  }

  Future<void> _loadTimeZones() async {
    final responseTimezones = await http
        .get(Uri.parse('https://timeapi.io/api/timezone/availabletimezones'));
    if (responseTimezones.statusCode == 200) {
      final jsonDataTimezones = json.decode(responseTimezones.body);
      List<dynamic> timeZoneList = jsonDataTimezones
          .map((zone) =>
              TimeZone(name: zone, offset: const Duration(seconds: 1)))
          .toList();

      setState(() {
        _timeZones = timeZoneList;
      });
    } else {
      throw Exception('Failed to load time zones');
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton(
            hint: const Text("Select Time Zone"),
            value: _selectedTimeZone,
            items: [
              const DropdownMenuItem<dynamic>(
                  value: null, child: Text("Clear Selection")),
              ..._timeZones.map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<TimeZone>(
                  value: value,
                  child: Text(value.name),
                );
              })
            ],
            onChanged: (dynamic newValue) {
              setState(() {
                _selectedTimeZone = newValue;
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _selectedTimeZone == null ? _timeZones.length : 1,
        itemBuilder: (context, index) {
          final timeZone = _selectedTimeZone ?? _timeZones[index];
          return TimeZoneCard(
            timeZone: timeZone,
            clock: _formatClock(timeZone.offset.inSeconds),
          );
        },
      ),
    );
  }

  String _formatClock(int offsetInSeconds) {
    final offset = Duration(seconds: offsetInSeconds);
    // final intOffset = offset.inSeconds;
    final now = DateTime.now();
    final timeZone = now.toUtc().add(Duration(hours: offset.inHours));
    final hour = timeZone.hour > 12 ? timeZone.hour - 12 : timeZone.hour;
    final period = timeZone.hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = timeZone.minute.toString().padLeft(2, '0');
    final formattedSecond = timeZone.second.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute:$formattedSecond $period';
  }
}
