library log_writter;

import 'package:stack_trace/stack_trace.dart';
import 'package:dogger/src/config/log_fields.dart';

Map formMessage(List elements) {
  Map result = new Map();
  String err;
  String stack;
  String expObj;

  if (elements[5] != null) {
    err = Error.safeToString(elements[5]);
    stack = Trace.format(elements[5].stackTrace, terse: true);
  }

  if (elements[6] != null) {
    stack = Trace.format(elements[6], terse: true);
  }

  if (elements[7] != null) {
    expObj = elements[7].toString();
  }

  result[LogMessage.CurrentMode.index] = elements[0] ?? '';
  result[LogMessage.EntityType.index] = elements[1] ?? '';
  result[LogMessage.EntityId.index] = elements[2] ?? '';
  result[LogMessage.EventType.index] = elements[3] ?? '';
  result[LogMessage.Message.index] = elements[4] ?? '';
  result[LogMessage.Error.index] = err ?? '';
  result[LogMessage.StackTrace.index] = stack ?? '';
  result[LogMessage.Expose.index] = expObj ?? '';
  result[LogMessage.Group.index] = elements[8] ?? false;
  result[LogMessage.Isolate.index] = elements[9];

  return result;
}
