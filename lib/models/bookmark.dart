import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 0)
class Bookmark extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String imageUrl;

  @HiveField(3)
  late String url;

  @HiveField(4)
  late bool isBookmarked = false;
}

