abstract class Appender {
  List _template;

  List get logEntryTemplate;

  static append(Map Entry) {}
}

enum LogEntryValues {
  Classification,
  Date,
  ErrorStack,
  ErrorType,
  EventType,
  Grouping,
  IsolateId,
  Message,
  Object,
  otherStack,
  SourceEntity,
  SourceEntityID,
  Time,
}

enum ClassificationLevels {
    Error,
    Informational,
    Log,
    Warning,
}
