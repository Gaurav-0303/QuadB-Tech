import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic show;

  DetailsScreen({required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                show['image']?['original'] ?? '',
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/no_img.png', width: 100, height: 150, fit: BoxFit.cover,);
                },
              ),
              const SizedBox(height: 16.0),
        
              Text(
                "Name: ${show['name']}",
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
        
              Text(
                'Genres: ${show['genres'].join(', ')}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
        
              Text(
                'Language: ${show['language']}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
        
              Text(
                'Runtime: ${show['runtime']} minutes',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
        
              Text(
                'Schedule: ${show['schedule']['days'].join(', ')} at ${show['schedule']['time']}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
        
              Text(
                "Description: ${show['summary']?.replaceAll(RegExp('<[^>]*>'), '') ?? ''}",
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}