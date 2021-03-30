import 'dart:ui';

import 'package:books_labry/database/database_helyper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  int page,id;
  int currentbage3;

  PDFScreen({this.path,this.page,this.id,this.currentbage3});

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  int crentpage2;
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int pages = 0;
  int currentPage ;
  bool isReady = false;
  String errorMessage = '';
  TextEditingController _controllertext;
  int saerchpage = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controllertext = TextEditingController();
    setState(() {
      //currentPage = widget.page;
    });
    //print(currentPage);

  }
  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    BooksDataBaseHelper.instance.updateispage("page", "$currentPage", widget.id);
    print(currentPage);
    print("is colse !");
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final ifispause = state ==AppLifecycleState.paused;
    final ifisdestory = state == AppLifecycleState.detached;
    // if(ifispause){
    //   int task = await BooksDataBaseHelper.instance.updateispage("page", "$currentPage", widget.id);
    //   print(task);
    //   print("ispause");
    //   print(currentPage);
    // }
    // if(ifisdestory){
    //   Navigator.pop(context,currentPage);
    //   print("is destory");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
           showpdfnigthmode(),
          Positioned(
              top: 0,
              child: Padding(
                padding: const EdgeInsets.only(top : 40),
                child: forasteddetailes(
                  IconButton(
                      alignment: Alignment.centerLeft,
                      icon : Icon(Icons.arrow_back_ios,color: Colors.black,),
                    onPressed: ()=>Navigator.pop(context,currentPage),
                )
          ),
              )
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          ),
          Positioned(
            bottom: 0,
            child: Container(
            height: 50,
            width: 390,
            child: Card(
              child: Row(
                children: [
                  FutureBuilder<PDFViewController>(
                    future: _controller.future,
                    builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          onPressed: () async {
                            await snapshot.data.setPage(currentPage-1);
                          },
                        );
                      }

                      return Container();
                    },
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                    showCursor: false,
                    textAlign: TextAlign.center,
                    cursorWidth: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: _controllertext,
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600
                    ),
                    onChanged: (text){
                        setState(() {
                          saerchpage = int.parse(text);
                        });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 0,right: 0,bottom: 0),
                      hintText: "go to page....?",
                      hintStyle: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600
                      ),
                    ),

                  ),),
                  FutureBuilder<PDFViewController>(
                    future: _controller.future,
                    builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                          icon : Icon(Icons.double_arrow_rounded),
                          onPressed: () async {
                            await snapshot.data.setPage(saerchpage);
                          },
                        );
                      }

                      return Container();
                    },
                  ),
                  FutureBuilder<PDFViewController>(
                    future: _controller.future,
                    builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                          icon : Icon(Icons.arrow_forward_rounded),
                          onPressed: () async {
                            await snapshot.data.setPage(currentPage+1);
                          },
                        );
                      }

                      return Container();
                    },
                  ),
                ],
              ),
              color: Colors.white60,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),)
        ],
      ),

    );
  }
  Widget showpdfnigthmode() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: PDFView(
        filePath: widget.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: widget.page,
        fitPolicy: FitPolicy.BOTH,
        nightMode: true,
        preventLinkNavigation:
        false,
        // if set to true the link is handled in flutter
        onRender: (_pages) {
          setState(() {
            pages = _pages;
            isReady = true;
          });
        },
        onError: (error) {
          setState(() {
            errorMessage = error.toString();
          });
          print(error.toString());
        },
        onPageError: (page, error) {
          setState(() {
            errorMessage = '$page: ${error.toString()}';
          });
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onLinkHandler: (String uri) {
          print('goto uri: $uri');
        },
        onPageChanged: (int page, int total) {
          print('page change: $page/$total');
          setState(() {
            currentPage = page;
            crentpage2 = page;
          });
        },
      ),
    );
  }
    Widget showpdfnormalmode(){
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
          defaultPage: widget.page,
          fitPolicy: FitPolicy.BOTH,
          nightMode: false,
          preventLinkNavigation:
          false,
          // if set to true the link is handled in flutter
          onRender: (_pages) {
            setState(() {
              pages = _pages;
              isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              errorMessage = error.toString();
            });
            print(error.toString());
          },
          onPageError: (page, error) {
            setState(() {
              errorMessage = '$page: ${error.toString()}';
            });
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            _controller.complete(pdfViewController);
          },
          onLinkHandler: (String uri) {
            print('goto uri: $uri');
          },
          onPageChanged: (int page, int total) {
            print('page change: $page/$total');
            setState(() {
              currentPage = page;
              crentpage2 = page;
            });
          },
        ),
      );
  }
  Widget forasteddetailes(Widget child){
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10 , sigmaY: 10),
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          color: Colors.white60,
          child: child,
        ),
      ),
    );
  }
}