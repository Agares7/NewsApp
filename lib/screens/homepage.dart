import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detailpage.dart';
import '../providers/category.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  String appBarTitle = 'News App';
  late List<Article> articles;
  late List<Article> filteredArticles;
  late String selectedCategory;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    articles = [];
    filteredArticles = [];
    selectedCategory = 'general';
    fetchNews(selectedCategory);
  }

  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  Future<void> fetchNews(String category) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=4c277a88e77b46889030afa4b77a7d78';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articlesData = data['articles'];

      setState(() {
        selectedCategory = category;
        appBarTitle = 'News App - $category';
        articles = List<Article>.from(articlesData
            .map((article) => Article.fromJson(article))
            .where(
                (article) => article.imageUrl != null && article.imageUrl != '')
            .toList());
        filteredArticles = articles;
      });
    } else {
      // Handle error
      print('Failed to fetch news');
    }
  }

  void filterArticles(String query) {
    setState(() {
      filteredArticles = articles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: CategorySection(
          selectedCategory: selectedCategory,
          fetchNews: fetchNews,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterArticles(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      article.imageUrl != null && article.imageUrl != ''
                          ? Image.network(
                              article.imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported),
                      SizedBox(height: 8),
                      ListTile(
                        title: Text(article.title),
                        subtitle: Text(article.description),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(article: article),
                            ),
                          );
                        },
                      ),
                    ],
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

class Article {
  final Map<String, dynamic> source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String content;
  late bool isBookmarked;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.content,
    this.isBookmarked = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source'],
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
      isBookmarked: false,
    );
  }
}
