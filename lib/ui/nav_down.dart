import 'package:books_labry/database/database_helyper.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:books_labry/ui/card_books.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class nav_download extends StatefulWidget{
  nav_downloadState createState() => nav_downloadState();
}
class nav_downloadState extends State<nav_download> with WidgetsBindingObserver{
  Future<List<Model>> lsititems ;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updatelist();

  }
  void _updatelist(){
    setState(() {
      lsititems = BooksDataBaseHelper.instance.getbooksListtab('isdownload', '1');
    });
  }
  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool isresume = state == AppLifecycleState.paused;
    if(isresume){
      print("the book will rest");
      _updatelist();
    }
  }

  @override
  Widget build(context){
    return SingleChildScrollView(
      child : RefreshIndicator(
        onRefresh: (){
          _updatelist();
          return Future.value(false);
        },
        child: Padding(padding: EdgeInsets.all(40),
            child : Column( children : <Widget>[
              Text("books download" , style: GoogleFonts.pacifico(),),
              SizedBox(height: 30,),
              Container(
                height: 600,
                child: FutureBuilder(
                  future: lsititems,
                  builder: (context , data){
                    if (!data.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return _listbooks(data.data);
                  },
                ),
              ),
            ]

            )
        ),
      )
    );
  }
  Widget _listbooks(List<Model> model){
    if(model.length == 0){
      return Center(child: Container(child : Text("no books download!")));
    }else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: model.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
                height: 260,
                child :  _bookscard(model[index]));
          });
    }
  }
  Widget _bookscard(Model model){
    return cardbooks(name: model.name,id: model.id,url: model.url,tybe: model.tybe,photourl: model.photourl,isfavorites: model.isfavorites,isdownload: model.isdownload,path: model.path,page: model.page,);
  }


}