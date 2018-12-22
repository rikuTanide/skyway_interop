
import 'dart:html';

import 'package:skyway_interop/skyway.dart';
void main() async {
  var key = window.localStorage["skywayKey"];
  var peer = new Peer(key);
  await peer.onOpen;

  var peerID = window.localStorage["peerID"] ;

  var connection = await peer.connect(peerID);
  connection.send("no no");
  connection.onData.listen(onData);

}


void onData(String data){
  print(data);
}