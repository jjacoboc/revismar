
import 'article.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

@JsonSerializable()

class Section {
  int idtSection;
  int idtBook;
  String name;
  int order;
  int createdBy;
  DateTime createdDate;
  int updatedBy;
  DateTime updatedDate;
  List<Article> articles;

  Section(this.idtSection, this.idtBook, this.name, this.order, this.createdBy, this.createdDate, this.updatedBy, this.updatedDate, this.articles);

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);
}