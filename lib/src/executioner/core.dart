/// Handles all the inbound message and core run loop.
///
///
///
library logger.core;

import 'dart:isolate';
import 'dart:developer';
import 'package:dogger/src/config/message_types.dart';

main(List args, int message) {
  ReceivePort inBoundMessagePort = new ReceivePort();
  SendPort outBoundMessagePort;
  SendPort tempProvisionPort;
  String isolateID;
  String executorPath;

  if (args.length == 4) {
    log('Processing Startup Args');
    outBoundMessagePort = args[0]; // Regular out bound msg sent here.
    assert(outBoundMessagePort is SendPort);
    isolateID = args[1]; // ID the client knows this Isolate as.
    assert(isolateID is String && isolateID.isNotEmpty);
    executorPath = args[2]; // Codebase that this isolate has access to.
    assert(executorPath is String && executorPath.isNotEmpty);
    tempProvisionPort = args[3]; // Provisioning port.
    assert(tempProvisionPort is SendPort);

    /// Carry out a port exchange so client can send to inBoundMessagePort.
    if (message == 9999) {
      log('Hand Shake Commenced.');
      String onExitMessage = ("$isolateID : ${Isolate.current.hashCode}");
      List reply = [9999, inBoundMessagePort.sendPort, onExitMessage];
      tempProvisionPort.send(reply);
    }
  }

  inBoundMessagePort.listen((Map msg) {});
}
