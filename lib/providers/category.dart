import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login.dart';
import '../screens/bookmarkpage.dart';
import '../screens/profile.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final String category;
  final String selectedCategory;
  final Function(String) fetchNews;

  const CategoryTile({
    required this.title,
    required this.category,
    required this.selectedCategory,
    required this.fetchNews,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        fetchNews(category);
        Navigator.pop(context);
      },
      selected: selectedCategory == category,
    );
  }
}

class CategorySection extends StatelessWidget {
  final String selectedCategory;
  final Function(String) fetchNews;

  const CategorySection({
    required this.selectedCategory,
    required this.fetchNews,
  });

  void navigateToBookmarkedNews(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookmarkPage())); // Navigate to BookmarkPage
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Container(),
        ),
        Expanded(
          flex: 9,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 16),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  'General News / Home',
                  style: TextStyle(fontSize: 16),
                ),
                selected: selectedCategory == 'general',
                onTap: () {
                  fetchNews('general');
                  Navigator.pop(context);
                },
              ),
              ExpansionTile(
                leading: Icon(Icons.category),
                title: Text(
                  'Categories',
                  style: TextStyle(fontSize: 16),
                ),
                children: [
                  CategoryTile(
                    title: 'Entertainment News',
                    category: 'entertainment',
                    selectedCategory: selectedCategory,
                    fetchNews: fetchNews,
                  ),
                  CategoryTile(
                    title: 'Business News',
                    category: 'business',
                    selectedCategory: selectedCategory,
                    fetchNews: fetchNews,
                  ),
                  CategoryTile(
                    title: 'Science News',
                    category: 'science',
                    selectedCategory: selectedCategory,
                    fetchNews: fetchNews,
                  ),
                  CategoryTile(
                    title: 'Health News',
                    category: 'health',
                    selectedCategory: selectedCategory,
                    fetchNews: fetchNews,
                  ),
                  CategoryTile(
                    title: 'Sports News',
                    category: 'sports',
                    selectedCategory: selectedCategory,
                    fetchNews: fetchNews,
                  ),
                  CategoryTile(
                    title: 'Technology News',
                    category: 'technology',
                    selectedCategory: selectedCategory,
                    fetchNews: fetchNews,
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text(
                  'Bookmarked News',
                  style: TextStyle(fontSize: 16),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                onTap: () {
                  navigateToBookmarkedNews(context); // Navigate to BookmarkPage
                },
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Logout',
            style: TextStyle(fontSize: 16),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
