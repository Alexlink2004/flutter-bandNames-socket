import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  List<Band> bands = [];

  @override
  void initState() {
    SocketService _socketService =
        Provider.of<SocketService>(context, listen: false);
    _socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SocketService _socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'BandNames',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (_socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 0,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final SocketService _socketService =
    Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      onDismissed: (_) =>
      //borrar en el server
      _socketService.emit('delete-band', {
        'id': band.id,
      }),
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
        onTap: () =>
            _socketService.socket
                .emit('vote-band', {'id': band.id, 'votes': band.votes ?? 1}),
      ),
    );
  }

  void addNewBand() {
    SocketService _socketService =
    Provider.of<SocketService>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('New Band Name'),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  addBandTolist(textEditingController.text);

                  Navigator.pop(context);
                },
                child: Text('agregar'),
              ),
            ],
          ),
    );
  }

  void addBandTolist(String name) {
    final SocketService socketService =
    Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.emit('add-band', {
        'name': name,
        'votes': 0,
        'id': DateTime.now().toString(),
      });

      setState(() {});
    }
    //Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(
        band.name,
            () => band.votes.toDouble(),
      );
    });
    return Expanded(
      flex: 1,
      child: PieChart(dataMap: dataMap),
    );
  }
}
