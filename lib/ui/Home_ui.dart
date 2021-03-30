import 'package:books_labry/database/database_helyper.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:books_labry/ui/nav_down.dart';
import 'package:books_labry/ui/nav_fav.dart';
import 'package:books_labry/ui/nav_home.dart';
import 'package:books_labry/ui/nav_sea.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget{
  HomeState createState() => HomeState();

}

class HomeState extends State<Home>{
  int selectindex = 2;
   Future<List<Model>> top10_list;
  @override
  void initState(){
    super.initState();
  }

  Widget build(context){
    return Scaffold(
      body: SingleChildScrollView(child : Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50 , left: 10),
              child: Align(alignment: Alignment.bottomLeft,
              child: Text("Books Labyri",style: GoogleFonts.pacifico(fontSize: 24 , color: Colors.black , fontWeight: FontWeight.bold),),
              ),
            ),
            Stack(
              children: <Widget>[
                _navwidget.elementAt(selectindex)
              ],
            ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.folder,color: Colors.red),
          Icon(Icons.favorite,color: Colors.red),
          Icon(Icons.home,color: Colors.red,),
          Icon(Icons.search , color: Colors.red,)
        ],
        index: 2,
        onTap: (index){
          selectnav(index);
        },
        animationDuration: Duration(milliseconds: 180),
        backgroundColor: Colors.white,
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
      ),
    );

  }
  void selectnav( int index){
    setState(() {
      selectindex = index;
    });
  }
  List<Widget> _navwidget = <Widget>[
      nav_download(),
      nav_fav(),
      nav_home(),
      nav_sea(),
  ];


}