import 'dart:async';
import 'dart:js';


class Peer {

  JsObject _peer;

  Completer<void> _onOpen = new Completer();
  Future get onOpen => _onOpen.future;

  String _peerID;
  String get peerID => _peerID;

  StreamController<Connection> _onConnection = new StreamController();
  Stream<Connection> get onConnection => _onConnection.stream;

  Peer._(this._peer){
    _peer.callMethod("on" , ["open" , (String peerID){
      this._onOpen.complete();
      this._peerID = peerID;
    }]);

    _peer.callMethod("on" ,["connection" , (JsObject connection)async{
      this._onConnection.add(await Connection._onConnection(connection));
    }]);

  }

  factory Peer(String key) {

    var option = JsObject.jsify({"key": key});
    var peer = new JsObject(context['Peer'], [option]);


    return new Peer._(peer);
  }


  Future<Connection> connect(String peerID)  {

    var completer = new Completer<Connection>();

    JsObject connection = this._peer.callMethod("connect" , [ peerID ]);
    Connection._onConnection(connection).then((connection){
      completer.complete(connection);
    });
    return completer.future;
  }


}

class Connection {

  JsObject _connection;

  StreamController<String> _onData = new StreamController();
  Stream<String> get onData => _onData.stream;

  Connection(this._connection) {


    _connection.callMethod("on" , ["data" , (String data){
      this._onData.add(data);
    }]);

  }

  void send(String data) {
    this._connection.callMethod("send" , [data]);
  }

  static Future<Connection> _onConnection(JsObject connectionObj) {
    var completer = new Completer<Connection>();
    connectionObj.callMethod("on" , ["open" , () {
      print("open");
      completer.complete(new Connection(connectionObj));
    }]);
    return completer.future;
  }

}