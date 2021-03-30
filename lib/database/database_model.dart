class Model{
  int id,isdownload,isfavorites,page;
  String name,tybe,url,path,photourl;
  Model({this.id,this.name,this.tybe,this.url,this.path,this.photourl,this.isdownload,this.isfavorites,this.page});
  Map<String , dynamic> toMap(){
  final map = Map<String , dynamic>();
  if(id != null){
    map['id'] = id;
  }
  map['name'] = name;
  map['tybe'] = tybe;
  map['url'] = url;
  map['path'] = path;
  map['photourl'] = photourl; 
  map['isdownload'] = isdownload;
  map['isfavorites'] = isfavorites;
  map['page'] = page;
  }
  factory Model.fromMap(Map<String , dynamic> map){
    return Model(id: map['id'],name: map['name'],tybe: map['tybe'],url: map['url'],path: map['path'],photourl: map['photourl'],isdownload: map['isdownload'],isfavorites: map['isfavorites'] , page: map['page']);
  }

}