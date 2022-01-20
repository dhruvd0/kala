import 'dart:isolate';


class CustomIsolate {
  CustomIsolate() {
    Isolate.spawn((message) {}, 'Isolate Start')
        .then((value) => isolate = value);
  }

  Isolate? isolate;
  final ReceivePort receivePort = ReceivePort();

  void execute(Function<T>(Object arg) callable) {
    receivePort.sendPort.send(callable);
   // compute
  }
}
