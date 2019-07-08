import 'dart:convert';
import 'book.dart';
import 'bookList.dart';
import 'constants.dart';
import 'pdfViewer.dart';
import 'articleViewList.dart';
import 'dart:io';
import 'sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final bookViewList = new GlobalKey<_BookListPageState>();

class BookListPage extends StatefulWidget {
  BookListPage({ Key key }) : super(key: key);
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {

  bool _loadingInProgress = true;
  static List years;
  List<BookList> bookList;
  File document;

  @override
  initState() {
    super.initState();
    bookList = new List<BookList>();
    this.getYears();
  }

  ExpansionPanel expansionPanel(BookList item) {
    return new ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return new Container(
            padding: EdgeInsets.only(left: 5.0, top: 11.0),
            child: Text(
              'Año ' '${item.year}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid))),
          );
        },
        canTapOnHeader: true,
        body: Container(
          child:
            item != null ? StaggeredGridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(item.books.length, (index) {
                return Center (
                  child: Card(
                    semanticContainer: false,
                    shape: BeveledRectangleBorder(),
                    child: InkWell(
                      //onTap: () { this.goToPdfViewer(item.books[index]); },
                      onTap: () { this.toArticles(item.books[index]); },
                      child: Column(
                          children: <Widget>[
                            getFrontCover(item.books[index].year, item.books[index].edition),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Text('Edición #' + item.books[index].edition.toString(), style: TextStyle(fontSize: 13)),
                                ),
                                /*
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: GestureDetector(
                                          child: Text('Escuchar', style: TextStyle(fontSize: 13, color: Colors.blue, decoration: TextDecoration.underline)),
                                          onTap: () { this.toArticles(item.books[index]); },
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          child: Image(
                                            image: AssetImage('images/headsets.png'),
                                            height: 16.0,
                                            width: 16.0,
                                          ),
                                          onTap: () { this.toArticles(item.books[index]); },
                                        ),
                                        padding: EdgeInsets.only(left: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                                */
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                );
              }),
              staggeredTiles:
              item.books.map<StaggeredTile>((item) => StaggeredTile.fit(1)).toList(),
            ) : Container(),
        ),
        isExpanded: item.isExpanded
    );
  }

  Widget build(BuildContext context) {
    if (bookList == null) {
      // This is what we show while we're loading
      return new Container();
    }
    return new Scaffold(
        appBar: AppBar(
          title: Text('REVISMAR'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(2, 29, 38, 0.8),
          leading: Container(),
        ),
        body: _buildBody(),
      );
  }

  Widget _buildBody() {
    if (this._loadingInProgress) {
      return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text('cargando...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman')),
            )
          ],
        ),
      );
    } else {
      return new ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                bookList[index].isExpanded = !bookList[index].isExpanded;
              });
            },
            children: bookList.map(expansionPanel).toList(),
          ),
        ],
      );
    }
  }

  Widget getFrontCover(int year, int edition) {
    Image img = getFrontImage(year, edition);
    if(img == null) img = getDefaultCover();
    return img;
  }

  Widget getFrontImage(int year, int edition) {
    String strEdition = edition < 10 ? "0" + edition.toString() : edition.toString();
    String strYear = year.toString();
    return Image.network(
      Constants.url_bucket + strYear + Constants.separator + strEdition + Constants.separator + Constants.frontPage + strYear + edition.toString() + Constants.jpg_ext,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
    );
  }

  Widget getDefaultCover() {
    return Image(
      image: AssetImage(Constants.defaultCover),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
    );
  }

  void getYears()  {
    print("method getYears....");
    String yearList = "";
    http.get(
      Uri.encodeFull(Constants.url_years),
        //Uri.encodeFull('http://10.0.2.2:8084/years/'),
        headers: {"Accept": "application/json"}).then((http.Response response) {
          yearList = response.body;
          List<dynamic> listyears = json.decode(yearList);
          print(listyears);
          listyears.forEach((ele){
            getBooksByYear(ele);
          });
          bookList.sort((a, b) => a.year.compareTo(b.year));
          setState(() {
            this._loadingInProgress = false;
          });
    });
  }

  void getBooksByYear(int year)  {
    print("method getBooksByYear....");
    List<Book> books = new List<Book>();
    http.get(
      Uri.encodeFull(Constants.url_booksByYear + year.toString()),
        //Uri.encodeFull('http://10.0.2.2:8084/books/' + year.toString()),
        headers: {"Accept": "application/json"}).then((http.Response response) {
          List<dynamic> jsonbooks = json.decode(response.body);
          jsonbooks.forEach((dynamic ele) {
            final Book book = new Book(
                ele['idt_book'],
                ele['code'],
                ele['title'],
                ele['author'],
                ele['publisher'],
                ele['edition'],
                ele['year'],
                ele['url'],
                ele['createdBy'],
                ele['createdDate'],
                ele['updatedBy'],
                ele['updatedDate']
            );
            books.add(book);
          });
          setState(() {
            bookList.add(BookList(year: year.toString(), books: books));
          });
    });
  }

  goToPdfViewer(Book book) {
    if(book != null) {
      String url = book.url;
      String title = book.title;
      String year = book.year.toString();
      String edition = book.edition < 10 ? "0" + book.edition.toString() : book.edition.toString();
      if(url != null) {
        int i = url.lastIndexOf("/");
        String filename = url.substring(i + 1);
        Preference.load();
        Preference.setString('url', url);
        Preference.setString('year', year);
        Preference.setString('edition', edition);
        Preference.setString('title', title);
        Preference.setString('filename', filename);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewer(),
            )
        );
      }
    }
  }

  toArticles(Book book) {
    if(book != null) {
      int id = book.idtBook;
      String title = book.title;
      int year = book.year;
      int edition = book.edition;
      Preference.load();
      Preference.setInt('idtBook', id);
      Preference.setString('title', title);
      Preference.setInt('year', year);
      Preference.setInt('edition', edition);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleViewList(),
          )
      );
    }
  }
}
