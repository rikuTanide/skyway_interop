import 'dart:js';
import 'dart:html';

import 'package:websocket_rd/skyway.dart';

void main()async {
  var key = window.localStorage["skywayKey"];
  var peer = new Peer(key);
  await peer.onOpen;

  window.localStorage["peerID"] = peer.peerID;

  peer.onConnection.listen(onConnection);

}

void onConnection(Connection connection){
  connection.send("ok ok");
  connection.onData.listen(onData);
}

void onData(String data){
  print(data);
}