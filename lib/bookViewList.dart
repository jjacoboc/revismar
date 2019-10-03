import 'dart:convert';
import 'book.dart';
import 'bookList.dart';
import 'constants.dart';
import 'suscription.dart';
import 'articleViewList.dart';
import 'changePassword.dart';
import 'profile.dart';
import 'dart:io';
import 'sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final bookViewList = new GlobalKey<_BookListPageState>();

class BookListPage extends StatefulWidget {
  BookListPage({ Key key }) : super(key: key);
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  bool _loadingInProgress = true;
  static List years;
  List<BookList> bookList;
  List<BookList> audioBookList;
  File document;
  Map<String, dynamic> user;

  @override
  initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    bookList = new List<BookList>();
    audioBookList = new List<BookList>();
    Preference.load();
    this.user = jsonDecode(Preference.getString('user'));
    this.getAudioBooks();
    this.getBooks();
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
            physics: ClampingScrollPhysics(),
            children: List.generate(item.books.length, (index) {
              return Center (
                child: Card(
                  semanticContainer: false,
                  shape: BeveledRectangleBorder(),
                  child: InkWell(
                    onTap: () { this.toArticles(item.books[index]); },
                    child: Column(
                        children: <Widget>[
                          getFrontCover(item.books[index].year, item.books[index].edition),
                          Column(
                            children: <Widget>[
                              Container(
                                child: Text('Edición #' + item.books[index].edition.toString(), style: TextStyle(fontSize: 13)),
                              ),
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
          title: Text('Biblioteca'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(2, 29, 38, 0.8),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Color.fromRGBO(201, 135, 47, 1.0),
            tabs: [
              new Tab(icon: new Icon(Icons.volume_up), text: 'Audio Revistas',),
              new Tab(icon: new Icon(Icons.book), text: 'Revistas',)
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
        ),
        body: TabBarView(
          children: <Widget>[
            _buildAudioBookList(),
            _buildBookList()
          ],
          controller: _tabController
        ),
        drawer: _buildDrawer(),
      );
  }

  Widget _buildAudioBookList() {
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
                audioBookList[index].isExpanded = !audioBookList[index].isExpanded;
              });
            },
            children: audioBookList.map(expansionPanel).toList(),
          ),
        ],
      );
    }
  }

  Widget _buildBookList() {
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(2, 29, 38, 1.0),
                    Color.fromRGBO(2, 29, 38, 0.8)
                  ],
                )
            ),
            accountName: Row(
              children: <Widget>[
                Icon(Icons.account_circle, color: Colors.white, size: 18),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(this.user['names'] + ' ' + this.user['last_names']),
                ),
              ],
            ),
            accountEmail: Row(
              children: <Widget>[
                Icon(Icons.email, color: Colors.white, size: 18),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(this.user['email']),
                ),
              ],
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(242, 240, 242, 1),
                border: Border.all(style: BorderStyle.solid, color: Colors.white, width: 5),
                image: DecorationImage(image: AssetImage('images/avatar/avatar' + user['avatar'] + '.jpg'))
              ),
              width: 110,
              height: 110,
            )
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.bookOpen, color: Color.fromRGBO(2, 29, 38, 1.0), size: 18,),
            title: Text('Biblioteca'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookListPage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.key, color: Color.fromRGBO(2, 29, 38, 1.0), size: 18,),
            title: Text('Cambiar Contraseña'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.solidAddressCard, color: Color.fromRGBO(2, 29, 38, 1.0), size: 18,),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.red, size: 18,),
            title: Text('Salir', style: TextStyle(color: Colors.red),),
            onTap: () {
              exit(0);
            },
          ),
          Divider(color: Color.fromRGBO(2, 29, 38, 1.0),),
          ListTile(
            title: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.subscriptions, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Suscribirse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color: Colors.white),),
                    ),
                  ],
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuscriptionPage(),
                      ));
                }
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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

  void getAudioBooks()  {
    String yearList = "";
    http.get(
        Uri.encodeFull(Constants.url_years + Constants.Audio_Book),
        //Uri.encodeFull('http://10.0.2.2:8084/years/'),
        headers: {"Accept": "application/json"}).then((http.Response response) {
      yearList = response.body;
      List<dynamic> listyears = json.decode(yearList);
      listyears.forEach((dynamic node) {
        List<Book> books = new List<Book>();
        List<dynamic> listBooks = node['books'];
        String year = node['year'].toString();
        listBooks.forEach((dynamic ele) {
          final Book book = new Book(
              ele['idt_book'],
              ele['code'],
              ele['title'],
              ele['author'],
              ele['publisher'],
              ele['edition'],
              ele['year'],
              ele['url'],
              ele['has_audio'],
              ele['createdBy'],
              ele['createdDate'],
              ele['updatedBy'],
              ele['updatedDate']
          );
          books.add(book);
        });
        setState(() {
          audioBookList.add(BookList(year: year, books: books));
        });
      });
      setState(() {
        this._loadingInProgress = false;
      });
    });
  }

  void getBooks()  {
    String yearList = "";
    http.get(
      Uri.encodeFull(Constants.url_years + Constants.No_Audio_Book),
        //Uri.encodeFull('http://10.0.2.2:8084/years/'),
        headers: {"Accept": "application/json"}).then((http.Response response) {
          yearList = response.body;
          List<dynamic> listyears = json.decode(yearList);
          print(listyears);
          listyears.forEach((dynamic node) {
            List<Book> books = new List<Book>();
            List<dynamic> listBooks = node['books'];
            String year = node['year'].toString();
            listBooks.forEach((dynamic ele) {
              final Book book = new Book(
                ele['idt_book'],
                ele['code'],
                ele['title'],
                ele['author'],
                ele['publisher'],
                ele['edition'],
                ele['year'],
                ele['url'],
                ele['has_audio'],
                ele['createdBy'],
                ele['createdDate'],
                ele['updatedBy'],
                ele['updatedDate']
              );
              books.add(book);
            });
            setState(() {
              bookList.add(BookList(year: year, books: books));
            });
          });
          setState(() {
            this._loadingInProgress = false;
          });
    });
  }

  toArticles(Book book) {
    if(book != null) {
      int id = book.idtBook;
      String title = book.title;
      int year = book.year;
      int edition = book.edition;
      int hasAudio = book.hasAudio;
      Preference.load();
      Preference.setInt('idtBook', id);
      Preference.setString('title', title);
      Preference.setInt('year', year);
      Preference.setInt('edition', edition);
      Preference.setInt('hasAudio', hasAudio);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleViewList(),
          )
      );
    }
  }
}
