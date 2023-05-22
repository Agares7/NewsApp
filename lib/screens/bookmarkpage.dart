import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bookmark.dart';
import 'detailbookmark.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final bookmarkBox = Hive.box<Bookmark>('bookmarks');
  late List<Bookmark> bookmarkList;
  late List<Bookmark> filteredBookmarks;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookmarkList = bookmarkBox.values
        .where((bookmark) => bookmark.isBookmarked)
        .toList();
    filteredBookmarks = bookmarkList;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterBookmarks(String query) {
    setState(() {
      filteredBookmarks = bookmarkList
          .where((bookmark) =>
              bookmark.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterBookmarks(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = filteredBookmarks[index];

                return ListTile(
                  title: Text(bookmark.title),
                  subtitle: Text(bookmark.description),
                  leading: Image.network(
                    bookmark.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailBookmark(bookmark: bookmark),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bookmark removed'),
                          backgroundColor: Colors.black,
                        ),
                      );
                      bookmarkBox.deleteAt(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
