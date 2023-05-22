import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/bookmark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homepage.dart';

class DetailPage extends StatefulWidget {
  final Article article;
  

  const DetailPage({required this.article});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ValueNotifier<bool> _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = ValueNotifier(false);
    _checkIsArticleBookmarked();
  }

  @override
  void dispose() {
    _isBookmarked.dispose();
    super.dispose();
  }

  Future<void> _checkIsArticleBookmarked() async {
    final bookmarkBox = Hive.box<Bookmark>('bookmarks');
    final index = bookmarkBox.values.toList().indexWhere(
          (bookmark) => bookmark.url == widget.article.url,
        );
    _isBookmarked.value = index != -1;
  }

  Future<void> _addBookmark() async {
    final bookmarkBox = Hive.box<Bookmark>('bookmarks');
    final bookmark = Bookmark()
      ..title = widget.article.title
      ..description = widget.article.description
      ..imageUrl = widget.article.imageUrl
      ..url = widget.article.url
      ..isBookmarked = true;

    await bookmarkBox.add(bookmark);
    _isBookmarked.value = true;
  }

  Future<void> _removeBookmark() async {
    final bookmarkBox = Hive.box<Bookmark>('bookmarks');
    final index = bookmarkBox.values.toList().indexWhere(
          (bookmark) => bookmark.url == widget.article.url,
        );
    if (index != -1) {
      await bookmarkBox.deleteAt(index);
      _isBookmarked.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _isBookmarked,
            builder: (context, isBookmarked, _) {
              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isBookmarked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bookmark removed'),
                        backgroundColor: Colors.black,
                      ),
                    );
                    _removeBookmark();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to Bookmark'),
                        backgroundColor: Colors.black,
                      ),
                    );
                    _addBookmark();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.title,
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.article.author + " - " + widget.article.publishedAt,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              if (widget.article.imageUrl != null &&
                  widget.article.imageUrl.isNotEmpty)
                Image.network(
                  widget.article.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16.0),
              SizedBox(height: 8.0),
              Text(widget.article.content, textAlign: TextAlign.justify),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  launch(widget.article.url);
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
