/// Dogger's core API.
library dogger.api;

import 'dart:async';

import 'package:darpule/tuple.dart';
import 'package:dogger/src/config/config.dart';
import 'package:dogger/src/config/message_types.dart';
import 'package:dogger/src/message_writer.dart';
import 'package:isodance/isodance.dart';

export 'package:dogger/src/config/message_types.dart';

/// Type of the logging function, calling of which causes a look entry to be created and appended.
///
/// Event is required and is one of the enumerated event types, message is a pass tense
/// description adding to the understanding of the event. Error is and any received error object
/// sTrace can be used if you want to pass the stack but don't have error object containing the stack
/// expose can contain an object that you want to 'toString' and groups causes entry to grouped.
typedef logFunction(Event event,
    {String msg, Error error, StackTrace sTrace, Object expose, bool group});

/// Singular Instance of the Lodging Service.
///
/// The only logger class responsible for providing closure function that wrap
/// all the contextual information for the enrichment of the logging message.
class DoggerService {
  static DoggerService _instance;
  ReceivePort _inBoundMsgPort;
  LogMode _currentMode;
  Uri _executor;
  bool _isExecutorRunning = false;
  Tuple _provisionedIsolatePackage;
  SendPort _logPort;

  /// Returns the logging service, optionally passing a Send will route the service
  /// output back to a receive port in a test suite.
  factory DoggerService(LogMode mode, {SendPort testPort}) {
    if (_instance == null) {
      _instance = new DoggerService._(mode, testPort);
    }
    return _instance;
  }
  DoggerService._(LogMode mode, SendPort port) {
    if (port != null) {
      _logPort = port;
      _isExecutorRunning = true;
    }
    _currentMode = mode;
    _executor = new Uri.file(frConfig(Parameter.loggingExecutor));
    assert(_executor != null);
  }

  /// Returns a ReceivePort that messages from the log process is sent to.
  ReceivePort get inBoundPort => _inBoundMsgPort;

  /// Returns true if the service has acquired and isolate and the possessor is
  /// running on that isolate.
  bool get isExecutorRunning => _isExecutorRunning;

  // Private Constructor.
  LogMode get logMode => _currentMode;

  ///  Returns on the logger function for a particular object or function.
  ///  Should the service not have acquired an isolate, the first call here will
  ///  cause it to do so.
  Future<logFunction> logger(Object entityToLog) async {
    String entityType = entityToLog.runtimeType.toString();
    int entityID = entityToLog.hashCode;

    // Returned Log Function
    void log(Event event,
        {String msg,
        Error error,
        StackTrace sTrace,
        Object expose,
        bool group: false}) {
      Map rawEntry = formMessage([
        _currentMode.index,
        entityType,
        entityID,
        event.index,
        msg,
        error,
        sTrace,
        expose,
        group,
        Isolate.current.hashCode
      ]);
      _logPort.send(rawEntry);
    }

    if (_isExecutorRunning) {
      assert(_logPort != null);
    }

    if (!_isExecutorRunning) {
      assert(_executor != null);
      assert(_inBoundMsgPort != null);
      Tuple isoRequest = new Tuple([_executor, _inBoundMsgPort]);
      _provisionedIsolatePackage = await provisionIsolate(isoRequest);
      _logPort = _provisionedIsolatePackage[1];
      assert(_logPort != null);
      _isExecutorRunning = true;
      return log;
    }

    return log;
  }

  /// Changes the current logging mode of the dogger;
  switchLogModeTo(LogMode mode) {
    Map configChange = {
      'parameter': 'logMode',
      'current': _currentMode,
      'changeTo': mode.index
    };
    _logPort.send(configChange);
    _currentMode = mode;
    // above could fail, we should listen for
    // a confirmation on the receive port.
  }
}
