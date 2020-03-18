import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: Scaffold(
              body: StreamBuilder(
          stream: Firestore.instance.collection('brandnames').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text("Loading...");
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context , index) =>
                _buildListItem(context, snapshot.data.documents[index]),
              );
          },
          ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return ListTile(
      title: Row(children: <Widget>[
        Expanded(child: 
          Text(document['name'])

        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffddddff)
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
           document['votes'].toString()
          ),
        )
      ],),
      onLongPress: (){
        print("Long pressed");
      },
      onTap: (){
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot firesnap = 
            await transaction.get(document.reference);
          await transaction.update(firesnap.reference,{
            'votes': firesnap['votes'] + 1,
          } );
        });
        print("Should increese vote");
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Fire Store"),
//       ),
//       body: Center(
//         child: Text("Texter Dilshad"),
//       ),
//     );
//   }
  
// }
