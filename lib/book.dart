import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()

class Book {
  int idtBook;
  String code;
  String title;
  String author;
  String publisher;
  int edition;
  int year;
  String url;
  int createdBy;
  DateTime createdDate;
  int updatedBy;
  DateTime updatedDate;

  Book(this.idtBook, this.code, this.title, this.author, this.publisher, this.edition, this.year, this.url, this.createdBy, this.createdDate, this.updatedBy, this.updatedDate);

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}