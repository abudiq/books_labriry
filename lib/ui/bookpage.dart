import 'dart:io';
import 'dart:ui';
import 'package:books_labry/database/database_helyper.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:books_labry/ui/pdfonline.dart';
import 'package:books_labry/ui/showpdf.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


class bookPage extends StatefulWidget{
  String name,tybe,url,photourl,path;
  int id,isdownload,isfavorites , page;

  bookPage({this.name,this.tybe,this.photourl,this.url,this.id,this.isdownload,this.isfavorites,this.path,this.page});
  bookPageState createState() => bookPageState();
}
class bookPageState extends State<bookPage> with SingleTickerProviderStateMixin{
  bool isfav,isdownload;
  bool loading = false;
  double progers = 0.0;
  final Dio dio = Dio();
  String finalpath = "";
  Directory directory;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Future<bool> saveFile(String path , String filenamed) async{
    try{
      if(Platform.isAndroid){
        if(await _requsetpermission(Permission.storage)){
          directory = await getExternalStorageDirectory();
          String newpath = "";
          List<String> folders = directory.path.split("/");
          for(int x=1 ; x<folders.length ; x++){
            String folder = folders[x];
            if(folder != 'Android'){
              newpath += "/"+folder;
            }else{
              break;
            }
          }
          newpath = newpath + "/books";
          directory = new Directory(newpath);
          print(directory.path);
        }
      }else{
        if(await _requsetpermission(Permission.photos)){
          directory = await getTemporaryDirectory();
        }else{
          return false;
        }
      }
      if(! await directory.exists()){
        await directory.create(recursive: true);
      }
      if(await directory.exists()){
        File savefile = File(directory.path+"/$filenamed.pdf");
        finalpath = savefile.path;
        await dio.download(widget.url, savefile.path,onReceiveProgress: (download , totalsize){
          setState(() {
            progers = download/totalsize;
          });
        });
        if(Platform.isIOS){
          ImageGallerySaver.saveFile(savefile.path , isReturnPathOfIOS: true);
        }
        return true;
      }

    }catch(e){
      print(e);
    }
    return false;
  }
  downloadfile(String url , String name) async{
    setState(() {
      loading = true;
    });
    bool state = await saveFile(url, name);
    if(state){
      print('complate download ');
      // Model model = Model(id: widget.id,name: widget.name,tybe: widget.tybe,url: widget.url,photourl: widget.photourl,path: finalpath ,isdownload: 1,isfavorites: widget.isfavorites);
      BooksDataBaseHelper.instance.updatebook("path" , "${finalpath}" , widget.id);
      BooksDataBaseHelper.instance.updateisdown("isdownload", "1", widget.id);
      shownotification(widget.id, widget.name, "is complet");
      // directory.deleteSync(recursive: true);
      widget.path = finalpath;
      setState(() {
        isdownload = true;
      });
    }else{
      print('download filed');
      shownotification(widget.id, widget.name, "is filed");
    }
    setState(() {
      loading = false;
    });

  }

  @override
  void initState(){
    super.initState();
    setState(() {
      isfav = checkit(widget.isfavorites);
      isdownload = checkdownload(widget.isdownload);
    });
    var androidintilize = new AndroidInitializationSettings('app');
    var iosintilize = new IOSInitializationSettings();
    var initilizatiosetting = new InitializationSettings(android: androidintilize , iOS: iosintilize);
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initilizatiosetting);
  }
  Future shownotification(int id , String title , String body) async{
    var androidDetails = new AndroidNotificationDetails("0", "channelName", "channelDescription" , importance: Importance.max);
    var iosdetils = new IOSNotificationDetails();
    var generalnotificationdetails = new NotificationDetails(android: androidDetails , iOS: iosdetils);
    await _flutterLocalNotificationsPlugin.show(id, title, body, generalnotificationdetails);
  }

  @override
  Widget build(context){
    final double pearsent = progers *100;
    return Scaffold(
      body: SingleChildScrollView(child : Center(
        child: Padding(
          padding: EdgeInsets.only(top: 35),
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    FadeInImage.assetNetwork(placeholder: 'assets/nophoto.jpg', image: widget.photourl ,width: 600,fit: BoxFit.cover,),
                    Container(
                      child : forasteddetailes((isfav == false) ? IconButton(icon: Icon(Icons.favorite,color: Colors.black,), onPressed: (){
                        setState(() {
                          isfav = !isfav;
                          putinfav(isfav, widget.id);
                          print(isfav);
                        });
                        
                      }
                      ) : IconButton(icon: Icon(Icons.favorite,color: Colors.red,), onPressed: (){
                          setState(() {
                            isfav = !isfav;
                            putinfav(isfav, widget.id);
                            print(isfav);
                          });
                      }
                      ))
                      ),(isdownload == true) ?
                    Positioned(
                      top: 0,
                        child: forasteddetailes( IconButton(icon : Icon(Icons.delete) , onPressed: () async{
                          bool isdelete = await _deletefile(widget.path);
                          if(isdelete = true){
                            setState(() {
                              isdownload = false;
                            });
                            BooksDataBaseHelper.instance.updatebook("path" , " " , widget.id);
                            BooksDataBaseHelper.instance.updateisdown("isdownload", "0", widget.id);

                          }
                        })
                        )) :  SizedBox(height: 0,width: 0,),

                  ],
                ),
                SizedBox(height: 10,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  shadowColor: Colors.red,
                  elevation: 8,
                  child: Container(
                    width: 500,
                    child: Column(
                      children: <Widget>[
                        Text(widget.name ,maxLines: 2, style: TextStyle(height: 1.5,
                            fontFamily: ArabicFonts.Cairo,
                            package: 'google_fonts_arabic',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                        ),
                        ),

                        Row(
                          children: <Widget>[

                            Padding(padding: EdgeInsets.only(left: 70,bottom: 5),
                              child: Align(
                                alignment: Alignment.bottomLeft,

                                child: (!isdownload) ? OutlineGradientButton(
                                  child: Text("download"),
                                  elevation: 10,
                                  gradient: LinearGradient(colors: [Colors.red,Colors.redAccent,Colors.black]),
                                  onTap: (){
                                    downloadfile(widget.url, "${widget.name}");

                                  },
                                  strokeWidth: 4,
                                  radius: Radius.circular(20),
                                ):OutlineGradientButton(
                                  child: Text("open file"),
                                  elevation: 10,
                                  gradient: LinearGradient(colors: [Colors.red,Colors.redAccent,Colors.black]),
                                  onTap: (){
                                    print(widget.path);
                                    showpdf(widget.path , widget.page , widget.id);

                                  },
                                  strokeWidth: 4,
                                  radius: Radius.circular(20),
                                )
                                ,),
                            ),
                            Padding(padding: EdgeInsets.only(left: 90),
                              child: Align(
                                alignment: Alignment.bottomRight,

                                child: OutlineGradientButton(
                                  child: Text("open online"),
                                  elevation: 10,
                                  gradient: LinearGradient(colors: [Colors.red,Colors.redAccent,Colors.black]),
                                  onTap: (){
                                    showpdfonline(widget.url);
                                  },
                                  strokeWidth: 4,
                                  radius: Radius.circular(20),
                                ),),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        (loading == true) ? Container(
                          height: 60,
                          child: LiquidLinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.red),
                            value: progers,
                            center: Text('${pearsent.toStringAsFixed(0)}%'),
                            direction: Axis.horizontal,
                            backgroundColor: Colors.white60,
                            borderRadius: 18.0,
                          ),
                        ) : Container(height: 0,)
                        

                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
            )
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
          color: Colors.white.withOpacity(0.3),
          child: child,
        ),
      ),
    );
  }
  bool checkit(int isfav){
    if(isfav == 0){
      return false;
    }else{
      return true;
    }
  }
  Future<bool>  _requsetpermission(Permission permission) async{
    if(await permission.isGranted){
      return true;
    }else{
      var result = await permission.request();
      if(result == PermissionStatus.granted){
        return true;
      }else{
        return false;
      }
    }

  }
  void putinfav(bool istrue , int id){
    if(istrue){
      BooksDataBaseHelper.instance.updatefav("isfavorites", "1", id);
    }else{
      BooksDataBaseHelper.instance.updatefav("isfavorites", "0", id);

    }
    
  }
  bool checkdownload(int value){
    if(value == 0){
      return false;
    }else{
      return true;
    }

  }
  Future<bool>  _deletefile(String path) async{
   File f = new File(path);
   try{
      await f.delete();
      return true;
   }catch(e){
     print(e);
   }
    return false;
  }
  void showpdfonline(String path){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreenonline(path: widget.url,)));
  }
  void showpdf(String path ,int page , int id) async{
      final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PDFScreen(path: path,page: page,id: id,currentbage3: 2,))
      );
      print("the resilt is $result");
  }


}