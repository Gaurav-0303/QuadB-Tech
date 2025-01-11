import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/detailsScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List searchResults = [];

  searchShows(String searchTerm) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = data;
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search for a movie...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                searchShows(searchController.text);
              },
            ),
          ),
          onSubmitted: (value) {
            searchShows(value);
          },
        ),
      ),
      body: searchResults.isEmpty
          ? const Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final show = searchResults[index]['show'];
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
