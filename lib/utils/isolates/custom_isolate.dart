import 'dart:isolate';

import 'package:flutter/foundation.dart';

class CustomIsolate {
  final ReceivePort receivePort = ReceivePort();
  Isolate? isolate;
  CustomIsolate() {
    Isolate.spawn((message) {}, "Isolate Start")
        .then((value) => isolate = value);
  }
  void execute(Function<T>(Object arg) callable) {
    receivePort.sendPort.send(callable);
   // compute
  }
}
