import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 3),
    Band(id: '2', name: 'Faraon love shady', votes: 4),
    Band(id: '3', name: 'Buefere', votes: 6),
    Band(id: '4', name: 'sanik', votes: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'BandNames',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 0,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      onDismissed: (direction) {
        //borrar en el server
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'DELETE ',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            band.name.substring(0, 2),
          ),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  void addNewBand() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Band Name'),
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              addBandTolist(textEditingController.text);
            },
            child: Text('agregar'),
          )
        ],
      ),
    );
  }

  void addBandTolist(String name) {
    if (name.length > 1) {
      this.bands.add(
            new Band(
              id: DateTime.now().toString(),
              name: name,
            ),
          );
      setState(() {});
    }
    Navigator.pop(context);
  }
}
