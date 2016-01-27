library log_entry;

import 'package:dogger/src/executioner/appender.dart';

/// Builds a log message based of the template specification of the
/// appender.
Map generateLogEntry(Map message, Appender appender){

    List template = appender.logEntryTemplate;



}

DateTime recoverDateTime(int microsecondsSinceEpoch) =>
    new DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
