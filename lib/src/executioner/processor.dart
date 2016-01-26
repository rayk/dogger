/// Processes each log message by routing it to a formatter and then an appender.

library processor;

import 'package:dogger/src/config/message_types.dart';
import 'package:lookup_map/lookup_map.dart';

const LookupMap msgTypeLookup =
    const LookupMap(const [Event.Error, errorEventProcessor]);

Event convertToEnum(int idx) {
  List events = Event.values;
  return events[idx];
}

Map errorEventProcessor(Map message) {}

processMessage(Map message) {
  Function processor;
  processor = msgTypeLookup[convertToEnum(message[3])];
  processor(message);
}
