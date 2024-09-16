import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_clock/models/time_zone.dart';

class TimeZoneCard extends StatelessWidget {
  final TimeZone timeZone;
  final String clock;

  const TimeZoneCard({super.key, required this.timeZone, required this.clock});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      child: SizedBox(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 150),
          child: Column(
            children: [
              Text(
                timeZone.name,
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeBox('Hrs', clock.substring(0, 2)),
                  _buildTimeBox('Mins', clock.substring(3, 5)),
                  _buildTimeBox('Secs', clock.substring(6, 8)),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTimeBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(36, 41, 45, 1),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.orbitron(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            label,
            style: GoogleFonts.orbitron(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
