// lib/presentation/widgets/airport_card.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/airport.dart';

class AirportCard extends StatelessWidget {
  final Airport airport;

  const AirportCard({Key? key, required this.airport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            // Display airport logo
            SizedBox(
              width: 48,
              height: 48,
              child: Image.memory(
                _decodeBase64Image(airport.airportLogo),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airport.airportName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE8ECF7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Code: ${airport.airportCode}',
                      style: const TextStyle(
                        color: Color(0xFF7B1FA2),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Color(0xFF7B1FA2)),
          ],
        ),
      ),
    );
  }

  // Helper method to decode base64 image
  Uint8List _decodeBase64Image(String base64String) {
    // Remove data:image/png;base64, prefix if present
    String sanitized = base64String;
    if (base64String.contains(',')) {
      sanitized = base64String.split(',')[1];
    }
    return base64Decode(sanitized);
  }
}
