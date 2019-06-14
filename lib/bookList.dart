import 'book.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class BookList {
  String year;
  List<Book> books;
  bool isExpanded;

  BookList({this.year, this.books, this.isExpanded: false});

  // getters
  String get getYear => year;
  List<Book> get getBooks => books;

  //setters
  set setYear(String value) {
    this.year = value;
  }

  set setBooks(List<Book> list) {
    this.books = list;
  }

  //json factory
  factory BookList.fromJson(List<dynamic> parsedJson) {
    List<Book> books = new List<Book>();
    books = parsedJson.map((i) => Book.fromJson(i)).toList();

    return new BookList(books: books);
  }
}