import 'package:books_labry/database/database_helyper.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:books_labry/ui/card_books.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:core';
class nav_sea extends StatefulWidget{
  nav_seaState createState() => nav_seaState();
}
class nav_seaState extends State<nav_sea>{
  Future<List<Model>> list_books;
  TextEditingController _controller = TextEditingController();
  @override
  void initState(){
    super.initState();
    _Searchnooks("");
  }
   _Searchnooks(String search){
    setState(() {
      list_books = BooksDataBaseHelper.instance.getbooksListsearch(search);
    });
  }

  @override
  Widget build(context){
    return SingleChildScrollView( 
        child : Padding(padding: EdgeInsets.all(30),
          child : Container(
            child: Column(
              children: [
          Padding(padding: EdgeInsets.only(top: 30),
            child: Text("What Went to Read ?" ,style: GoogleFonts.openSans( fontWeight: FontWeight.w700 , color: Colors.black , fontSize: 18),),
          ),
          Container(
            height: 39,
            margin: EdgeInsets.only(left: 30,right: 30,top: 18,),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black
            ),
            child: Stack(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  onChanged: (text){
                    setState(() {
                      _Searchnooks(text);
                    });

                  },
                  maxLengthEnforcement: MaxLengthEnforcement.enforced ,
                  style: GoogleFonts.openSans(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 19,right: 50,bottom: 8),
                      border: InputBorder.none,
                      hintText: "search books....",
                      hintStyle: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600
                      )
                  ),

                ),
                Positioned(right: 8,
                    height: 9,
                    child:
                    IconButton(
                      icon: Icon(Icons.search,color: Colors.redAccent,),
                      onPressed:
                          (){}
                      ,
                    )
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          FutureBuilder(
              future: list_books,
              builder: (context , data){
                if(!data.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return Center(
                  child: Container(
                    height: 600,
                    child: _listbooks(data.data),
                  ),
                );
          })
        ],
      ),
    )
    )
    );
  }
  Widget _listbooks(List<Model> list){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context , index){
          return Container(
            height: 300,
            child: _bookcards(list[index]),
          );

        });

  }
  Widget _bookcards(Model model){
    return cardbooks(name: model.name,tybe: model.tybe,photourl: model.photourl,url: model.url,id: model.id,isdownload: model.isdownload,isfavorites: model.isfavorites,path: model.path,page: model.page,);
  }
}