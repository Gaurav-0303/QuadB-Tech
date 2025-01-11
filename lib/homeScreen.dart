import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_app/detailsScreen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List shows = [];

  @override
  void initState() {
    super.initState();
    fetchShows();
  }

  fetchShows() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        shows = data;
      });
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: shows.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index]['show'];
                return Column(
                  children: [
                    ListTile(
                      leading: show['image']?['medium'] != null
                          ? Image.network(
                              show['image']['medium'],
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/no_img.png', width: 100, height: 150, fit: BoxFit.cover,);
                              },
                            )
                          : Image.asset('assets/images/no_img.png', width: 100, height: 150, fit: BoxFit.cover,),
                      title: Text(
                        show['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        show['summary']?.replaceAll(RegExp('<[^>]*>'), '') ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(show: show),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.grey),
                  ],
                );
              },
            ),
    );
  }
}