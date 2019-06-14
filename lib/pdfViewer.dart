import 'sharedPreferencesHelper.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';


class PdfViewer extends StatefulWidget {
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {

  bool _isLoading = true;
  File document;
  PDFDocument pdfDocument;
  String titleDocument;

  @override
  void initState() {
    super.initState();
    this.downloadFile();
  }

  downloadFile() async {
    Preference.load();
    String year = Preference.getString("year");
    String edition = Preference.getString("edition");
    String title = Preference.getString("title");
    String filename = Preference.getString("filename");

    var response = await http.get(
        Uri.encodeFull("http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/document/" + year + "/" + edition + "/" + filename));
        //Uri.encodeFull("http://10.0.2.2:8084/document/1907/04/AparatoDelCapitanScott.pdf"));

    var bytes = response.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    this.document = await file.writeAsBytes(bytes);
    setState(() {
      this.document = file;
      this.titleDocument = title;
    });
    this.loadDocument();
  }

  loadDocument() async {
    pdfDocument = await PDFDocument.fromFile(this.document);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: this.titleDocument != null ? Text(this.titleDocument) : Text(""),
            backgroundColor: Color.fromRGBO(2, 29, 38, 0.8),
          ),
          body: Center(
              child: _isLoading
                  ? Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text('cargando libro...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman')),
                      )
                    ],
                  )
              )
                  : PDFViewer(
                document: pdfDocument,
                //tooltip: PDFViewerTooltip(first: "Batatas")
              )
          ),
        ),
    );
  }
}