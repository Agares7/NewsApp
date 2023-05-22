import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/bookmark.dart';

class DetailBookmark extends StatelessWidget {
  final Bookmark bookmark;

  const DetailBookmark({Key? key, required this.bookmark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark Detail'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookmark.title,
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
                Image.network(
                  bookmark.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16.0),
              SizedBox(height: 8.0),
              Text(bookmark.description, textAlign: TextAlign.justify),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  launch(bookmark.url);
                },
                child: Text('Read More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
