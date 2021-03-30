import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf_platform_view/pdf_platform_view.dart';
import 'package:path_provider/path_provider.dart';


class PDFScreenonline extends StatefulWidget {
  String path;
  PDFScreenonline({this.path});
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreenonline> {
  File file;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        file = f;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    final url = widget.path;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  final _controller = PdfViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: file != null
          ? PdfView(
        file: file,
        controller: _controller,
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
