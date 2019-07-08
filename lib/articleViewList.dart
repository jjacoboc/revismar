import 'article.dart';
import 'section.dart';
import 'sectionList.dart';
import 'pdfViewer.dart';
import 'audioPlayer.dart';
import 'constants.dart';
import 'sharedPreferencesHelper.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticleViewList extends StatefulWidget {
  @override
  _ArticleViewListState createState() => new _ArticleViewListState();
}

class _ArticleViewListState extends State<ArticleViewList> {

  String title;
  int idtBook;
  String strYear;
  String strEdition;
  List<SectionList> sectionList;
  bool _loadingInProgress = true;

  @override
  void initState() {
    super.initState();
    sectionList = new List<SectionList>();
    Preference.load();
    this.idtBook = Preference.getInt('idtBook');
    this.strYear = Preference.getInt('year').toString();
    this.strEdition = Preference.getInt('edition') < 10 ? "0" + Preference.getInt('edition').toString() : Preference.getInt('edition').toString();
    this.title = Preference.getString('title') + " " + Preference.getInt('year').toString() + " #" + Preference.getInt('edition').toString();
    loadData();
  }

  loadData() {
    String sectionList = "";
    List<Section> sections = new List<Section>();
    http.get(
        //Uri.encodeFull(Constants.url_years),
        Uri.encodeFull(Constants.url_sections + this.idtBook.toString()),
        headers: {"Accept": "application/json"}).then((http.Response   response) {
      sectionList = response.body;
      List<dynamic> listSections = json.decode(sectionList);
      listSections.forEach((dynamic section){
        String body = "";
        List<Article> articles = new List<Article>();
        http.get(
          //Uri.encodeFull(Constants.url_years),
            Uri.encodeFull(Constants.url_articles + section['idt_section'].toString()),
            headers: {"Accept": "application/json"}).then((http.Response response) {
              body = response.body;
              List<dynamic> jsonArticles = json.decode(body);
              jsonArticles.forEach((dynamic ele){
                final Article node = new Article(
                    ele['idt_article'],
                    ele['idt_section'],
                    ele['name'],
                    ele['author'],
                    ele['order'],
                    ele['createdBy'],
                    ele['createdDate'],
                    ele['updatedBy'],
                    ele['updatedDate']
                );
                articles.add(node);
              });
              setState(() {
                this._loadingInProgress = false;
              });
        });
        final Section node = new Section(
            section['idt_section'],
            section['idt_book'],
            section['name'],
            section['order'],
            section['createdBy'],
            section['createdDate'],
            section['updatedBy'],
            section['updatedDate'],
            articles
        );
        sections.add(node);
      });
      setState(() {
        this.sectionList.add(SectionList(sections: sections));
        this._loadingInProgress = false;
      });
    });
  }

  toPdfViewer(String order, String article, String author, int i, int j) {
    Preference.load();
    Preference.setString('year', this.strYear);
    Preference.setString('edition', this.strEdition);
    Preference.setString('order', order);
    Preference.setString('indexSection', i.toString());
    Preference.setString('indexArticle', j.toString());
    if(author != '') {
      Preference.setString('article', article);
      Preference.setString('author', author);
    } else {
      Preference.setString('article', 'EDITORIAL');
      Preference.setString('author', article);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewer(),
        ));
  }

  toAudioBook(String order, String article, String author) {
    Preference.load();
    Preference.setString('year', this.strYear);
    Preference.setString('edition', this.strEdition);
    Preference.setString('order', order);
    if(author != '') {
      Preference.setString('article', article);
      Preference.setString('author', author);
    } else {
      Preference.setString('article', 'EDITORIAL');
      Preference.setString('author', article);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioApp(),
        ));
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
      return ListView.builder(
          shrinkWrap: true,
          itemCount: this.sectionList[0].sections.length,
          itemBuilder: (context, i) {
            String title = this.sectionList[0].sections[i].name.toUpperCase();
            Color _color = Color.fromRGBO(0, 39, 68, 1.0);
            if(title == 'SECCIÓN ESPECIAL') _color = Color.fromRGBO(199, 29, 64, 1.0);
            if(title == 'SECCIÓN NACIONAL') _color = Color.fromRGBO(0, 117, 148, 1.0);
            if(title == 'SECCIÓN INTERNACIONAL') _color = Color.fromRGBO(0, 160, 161, 1.0);
            if(title == 'SECCIÓN COMENTARIOS Y PUBLICACIONES') _color = Color.fromRGBO(180, 165, 153, 1.0);
            return Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      this.sectionList[0].sections[i].name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5.0),
                    decoration: BoxDecoration(color: _color),
                    width: MediaQuery.of(context).size.width,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.sectionList[0].sections[i].articles.length,
                    itemBuilder: (context, j) {
                      String ord = this.sectionList[0].sections[i].articles[j].order.toString();
                      String nam = this.sectionList[0].sections[i].articles[j].name.toUpperCase();
                      String aut = this.sectionList[0].sections[i].articles[j].author != null ?
                      this.sectionList[0].sections[i].articles[j].author.toUpperCase() : "";
                      return Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(ord + ". ", style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Container(
                                    child: Text(nam, style: TextStyle(fontSize: 14)),
                                    padding: EdgeInsets.only(right: 5.0),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: GestureDetector(
                                    child: Image(
                                      image: AssetImage('images/play_navy.jpg'),
                                      height: 16.0,
                                      width: 16.0,
                                    ),
                                    //onTap: () { this.toAudioBook(ord, nam, aut); },
                                    onTap: () { this.toPdfViewer(ord, nam, aut, i+1, j+1); },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(aut, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: this.title != null ? Text(this.title) : Text(""),
            backgroundColor: Color.fromRGBO(2, 29, 38, 0.8),
          ),
          body: Stack(
            children: <Widget>[
              Center(
                child: new Image.asset('images/sumario.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
              _buildBody(),
            ],
          ),

        ),
    );
  }
}