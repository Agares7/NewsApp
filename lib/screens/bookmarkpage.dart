import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bookmark.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarkBox = Hive.box<Bookmark>('bookmarks');
    final bookmarkList =
        bookmarkBox.values.where((bookmark) => bookmark.isBookmarked).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: bookmarkList.length,
        itemBuilder: (context, index) {
          final bookmark = bookmarkList[index];

          return ListTile(
            title: Text(bookmark.title),
            subtitle: Text(bookmark.description),
            leading: Image.network(
              bookmark.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bookmark removed'),
                    backgroundColor: Colors.black,
                  ),
                );
                final bookmarkBox = Hive.box<Bookmark>('bookmarks');
                bookmarkBox.deleteAt(index);
              },
            ),
          );
        },
      ),
    );
  }
}
