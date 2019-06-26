import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()

class Article {
  int idtArticle;
  int idtSection;
  String name;
  String author;
  int order;
  int createdBy;
  DateTime createdDate;
  int updatedBy;
  DateTime updatedDate;

  Article(this.idtArticle, this.idtSection, this.name, this.author, this.order, this.createdBy, this.createdDate, this.updatedBy, this.updatedDate);

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}