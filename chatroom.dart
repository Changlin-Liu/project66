import 'global.dart';
import 'package:flutter/material.dart';



class chatroomPage extends StatefulWidget {
  @override createState() => chatroomState();
}



class chatroomState extends State{


  @override
  void initState() {
    super.initState();
    getchat();

  }

  var nList = [];

  void getchat(){

    var nRef = dbRef.child('chatroom');

    nRef.onValue.listen((event) {
      if (event.snapshot.value != null)
        nList =  (event.snapshot.value as Map).values.toList();
      if (mounted) setState(() {});
    });
  }

  var content = '';



  void reply() {
    if (content != '')
    {

      var ref = dbRef.child('chatroom').push();
      ref.set({
        'content' : content,
        'key' : ref.key,
        'createdAt' : DateTime.now().millisecondsSinceEpoch,
        'createdBy' : userID,
      });

    } else {
      var alert = AlertDialog(
        title: Text('Sorry'),
        content: Text('The content can not be null.'),
      );
      showDialog(context: context, builder: (_)=>alert);
    }
  }



  Widget textComposerWidget(){
    return IconTheme(
        data: IconThemeData(color: Colors.blue),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Content',),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (text) => setState(() => content = text),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                  onPressed: () => reply(),),
              )
            ],
          ),
        )
    );
}



  @override Widget build(BuildContext context) {


    var commentList = <Widget>[];
    var data2 = List();

    data2.addAll(nList);


    data2.sort((a, b) => a['createdAt'] - b['createdAt']);


    for (var i=0; i<data2.length; i++){

      var item = data2[i];
      var content = item['content'];


      commentList.add(
          ListTile(
            leading: Stack(
                alignment: Alignment.topLeft,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        '$userID/images'),
                    radius: 20.0,
                  ),

                ]
            ),
            title: Text(item["createdBy"],
              style: TextStyle(color: Colors.blue,fontSize: 16.0),),

            subtitle: Text(content,
                style: TextStyle(color: Colors.black,fontSize: 18.0),),
          )
      );
    }





    return Scaffold(
      appBar: AppBar(
        title: Text('Chatroom'),


        actions: <Widget>[

             IconButton(
                 icon: Icon(Icons.delete_forever),
                 onPressed: () => delete(),
             )

        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:commentList,
              ),
            ],
          ),
          ),
          Divider(height: 1.0,),
          Container(
            child: textComposerWidget(),
          )
        ],
      ),
    );
  }





void delete() {

  dbRef.child('chatroom').remove();

  Navigator.pop(context);
}

}

