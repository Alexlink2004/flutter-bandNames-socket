import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Server Status: ${socketService.serverStatus}',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => socketService.emit(
          'emitir-mensaje',
          {
            'nombre': 'flutter',
            'mensaje': 'hola desde flutter',
          },
        ),
      ),
    );
  }
}
