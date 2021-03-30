import 'package:books_labry/ui/bookpage.dart';
import 'package:flutter/material.dart';
class cardbooks extends StatelessWidget{
  String name,tybe,url,photourl,path;
  int id,isdownload,isfavorites,page;
  cardbooks({this.name,this.tybe,this.photourl,this.isdownload,this.isfavorites,this.id , this.url , this.path,this.page});
  Widget build(context){
    return InkWell(child :
      Card(
      shadowColor: Colors.redAccent,
      elevation: 8,
      margin: EdgeInsets.all(5),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        height: 100,
        padding: EdgeInsets.only(top: 4),
        child: Column(

          children: <Widget>[
            FadeInImage.assetNetwork(
              height: 140,
                width: 200,
                placeholder: "assets/nophoto.jpg", image: photourl,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10,),
            Text(name ,style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
          ],


        ),
      ),
    ),
      onTap: (){
          Navigator.push(context, 
          MaterialPageRoute(builder: (BuildContext context ) => bookPage(name: name,tybe: tybe,photourl: photourl,url: url,isfavorites: isfavorites,isdownload: isdownload,id: id, path: path,page: page,))
          );
      },
    );
  }
}