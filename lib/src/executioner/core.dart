/// Handles all the inbound message and core run loop.
///
///
///
library logger.core;

import 'dart:isolate';
import 'dart:developer';
import 'package:dogger/src/executioner/processor.dart';
import 'package:dogger/src/executioner/logger_state.dart';

main(List args, int message) {
  ReceivePort inBoundMessagePort = new ReceivePort();
  SendPort outBoundMessagePort;
  SendPort tempProvisionPort;
  String isolateID;
  String executorPath;

  bool isConfigMessage(Map msg) => msg.containsKey('parameter');

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

  /// Handle each incoming message
  inBoundMessagePort.listen((Map msg) async {
    if (isConfigMessage(msg)) {
      LoggerState.update(msg);
    }
    process(msg).then((Map logEntry) {

    });
  });
}
