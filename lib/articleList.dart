import 'article.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class ArticleList {
  List<Article> articles;

  ArticleList({this.articles});

  List<Article> get getArticles => articles;

  set setArticles(List<Article> list) {
    this.articles = list;
  }

  //json factory
  factory ArticleList.fromJson(List<dynamic> parsedJson) {
    List<Article> articles = new List<Article>();
    articles = parsedJson.map((i) => Article.fromJson(i)).toList();

    return new ArticleList(articles: articles);
  }
}