import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  IO.Socket get socket => this._socket;

  ServerStatus get serverStatus => this._serverStatus;

  get emit => this._socket.emit;

  SocketService() {
    initConfig();
  }

  void initConfig() {
    // Dart client
    this._socket = IO.io('http://192.168.1.75:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;

      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    socket.on('emitir-mensaje', (payload) {
      print(
        'nuevo mensaje: ${payload}',
      );

      notifyListeners();
    });
  }
}
