import 'package:flutter/material.dart';

class PlaceDetailsPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String details;

  const PlaceDetailsPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(imagePath, height: 260, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(details, style: const TextStyle(fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }
}