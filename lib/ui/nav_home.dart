import 'package:books_labry/database/database_helyper.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'card_books.dart';
class nav_home extends StatefulWidget {
    nav_homeState createState() => nav_homeState();
}
class nav_homeState extends State<nav_home> {
  Future<List<Model>> top10_list;
  Future<List<Model>> romantic_list;
  Future<List<Model>> sad_list;
  Future<List<Model>> Police_list;

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child : Padding(padding: EdgeInsets.only(top: 20 , left: 10),
      child: Column(
        children: <Widget>[
          Text("top 10" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),),

          FutureBuilder(
              future: top10_list,
              builder: (context, data) {
                if (!data.hasData) {
                  return CircularProgressIndicator();
                }
                return Center(
                  child: Container(
                    height: 240,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: data.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            child: Listcard(data.data[index]),
                          );
                        }),
                  ),
                );
              }),
          SizedBox(height: 20,),
          Text("romantic" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),),

          FutureBuilder(
              future: romantic_list,
              builder: (context, data) {
                if (!data.hasData) {
                  return CircularProgressIndicator();
                }
                return Center(
                  child: Container(
                    height: 240,
                    color: Colors.white,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            child: Listcard(data.data[index]),
                          );
                        }),
                  ),
                );
              }),
          SizedBox(height: 20,),
          Text("sad" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),),

          FutureBuilder(
              future: sad_list,
              builder: (context, data) {
                if (!data.hasData) {
                  return CircularProgressIndicator();
                }
                return Center(
                  child: Container(
                    height: 240,
                    color: Colors.white,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            child: Listcard(data.data[index]),
                          );
                        }),
                  ),
                );
              }),
          SizedBox(height: 20,),
          Text("Police" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),),

          FutureBuilder(
              future: Police_list,
              builder: (context, data) {
                if (!data.hasData) {
                  return CircularProgressIndicator();
                }
                return Center(
                  child: Container(
                    height: 240,
                    color: Colors.white,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            child: Listcard(data.data[index]),
                          );
                        }),
                  ),
                );
              }),
        ],
      ),
    )
    );
  }

  void _updateList() {
    setState(() {
      top10_list =
          BooksDataBaseHelper.instance.getbooksListtab('tybe', 'top10');
      romantic_list =
          BooksDataBaseHelper.instance.getbooksListtab('tybe', 'romantic');
      sad_list =
          BooksDataBaseHelper.instance.getbooksListtab('tybe', 'sad');
      Police_list =
          BooksDataBaseHelper.instance.getbooksListtab('tybe', 'Police');
    });
  }
  Widget Listcard(Model model){
    return cardbooks(name: model.name,tybe: model.tybe,photourl: model.photourl,url: model.url,id: model.id,isdownload: model.isdownload,isfavorites: model.isfavorites, path: model.path,page: model.page,);
  }

}