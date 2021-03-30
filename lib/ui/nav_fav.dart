import 'package:books_labry/database/database_helyper.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'card_books.dart';

class nav_fav extends StatefulWidget{
  nav_favState createState() => nav_favState();
}
class nav_favState extends State<nav_fav>{
  Future<List<Model>> lsititems ;

  @override
  void initState(){
    super.initState();
    _updatelist();
  }
  void _updatelist(){
  setState(() {
    lsititems = BooksDataBaseHelper.instance.getbooksListtab("isfavorites", "1");

  });

}


  @override
  Widget build(context){
    return SingleChildScrollView(child :
      RefreshIndicator(
        onRefresh: (){
          _updatelist();
          return Future.value(false);
        },
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,width: 40,),
                  Padding(padding: EdgeInsets.only(top: 10),
                    child: Text("best for you ",style: GoogleFonts.pacifico(fontSize: 24 , color: Colors.black , fontWeight: FontWeight.bold ,),),
                  ),
                  SizedBox(height: 3,),
                  Container(height: 600,
                      child:   FutureBuilder(
                          future: lsititems,
                          builder: (context , data){
                            if(!data.hasData){
                              return Center(child: CircularProgressIndicator(),);
                            }
                            return _listbooks(data.data);
                          })
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
  Widget _listbooks(List<Model> list){
    if(list.length == 0){
      return Center(
        child: Container(
          child: Center(child: Text("no books is like you !" , style: GoogleFonts.openSans(fontSize: 24 , color: Colors.red),),)
        ),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context , index){
          return Container(
            height: 280,
            child: cardsbook(list[index]),
          );

        });

  }
  Widget cardsbook(Model model){
    return cardbooks(name: model.name,id: model.id,url: model.url,tybe: model.tybe,photourl: model.photourl,isfavorites: model.isfavorites,isdownload: model.isdownload,path: model.path,page: model.page,);
  }

}