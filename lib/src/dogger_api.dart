library dogger.api;

import 'dart:async';

import 'package:darpule/tuple.dart';
import 'package:dogger/src/config/config.dart';
import 'package:dogger/src/config/message_types.dart';
import 'package:dogger/src/message_writer.dart';
import 'package:isodance/isodance.dart';

export 'package:dogger/src/config/message_types.dart';

typedef logFunction(Event event,
    {String msg, Error error, StackTrace sTrace, Object expose, bool group});

/// Singleton Logging service
class DoggerService {
  static DoggerService _instance;
  ReceivePort _inBoundMsgPort;
  LogMode _currentMode;
  Uri _executor;
  bool _isExecutorRunning = false;
  Tuple _provisionedIsolatePackage;
  SendPort _logPort;

  bool get isExecutorRunning => _isExecutorRunning;
  ReceivePort get inBoundPort => _inBoundMsgPort;
  LogMode get logMode => _currentMode;

  factory DoggerService(LogMode mode, {SendPort testPort}) {
    if (_instance == null) {
      _instance = new DoggerService._(mode, testPort);
    }
    return _instance;
  }

  // Private Constructor.
  DoggerService._(LogMode mode, SendPort port) {
    if (port != null) {
      _logPort = port;
      _isExecutorRunning = true;
    }
    _currentMode = mode;
    _executor = new Uri.file(frConfig(Parameter.loggingExecutor));
  }

  /// Changes the current logging mode of the dogger;
  switchLogModeTo(LogMode mode) {
    _currentMode = mode;
  }

  ///  Returns on the logger function for a particular object or function.
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
}
