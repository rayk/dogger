/// Processor produces the a fully encapsulated entry, along with meta details.
/// that allows the router to forward the entry to the correct appender.
library processor;

import 'dart:async';

import 'package:dogger/src/config/message_types.dart';
import 'package:dogger/src/executioner/appender.dart';
import 'package:dogger/src/executioner/log_entry.dart';
import 'package:dogger/src/executioner/logger_state.dart';

/// Returns a map which includes the appender and a formatted
/// log entry. Give the current logger state and any overrides
/// which have been included.
Future<Map> process(Map message) async {
  Appender appender = selectAppender(Event.values[3]);
  return await generateLogEntry(message, appender);
}

