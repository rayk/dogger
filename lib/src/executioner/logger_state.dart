/// Manages the state of the logger.
library loggerState;

import 'package:dogger/src/config/message_types.dart';
import 'package:dogger/src/executioner/append_webConsole.dart';
import 'package:dogger/src/executioner/appender.dart';
import 'package:dogger/src/executioner/discarder.dart';
import 'package:lookup_map/lookup_map.dart';

/// Default appender for each mode.
const LookupMap defaultAppender = const LookupMap<LogMode, Appender>(const [
  LogMode.Development,
  WebConsole.append,
  LogMode.Diagnostic,
  WebConsole.append,
  LogMode.Production,
  WebConsole.append
]);

/// In Development Mode, these events will have an alternative treatment, either
/// alternatively output to a different destination or will not even be exist.
const LookupMap developmentOverrideLookUp = const LookupMap<Event, Appender>(
    const [Event.ArgumentError, WebConsole.append]);

/// In Diagnostic Mode, these events will have an alternative treatment, either
/// alternatively output to a different destination or will not even be exist.
const LookupMap diagnosticOverrideLookUp = const LookupMap<Event, Appender>(
    const [Event.UnsupportedError, WebConsole.append]);

/// Map of the overrides for the three different modes.
const LookupMap overrideMaps = const LookupMap<LogMode, LookupMap>(const [
  LogMode.Development,
  developmentOverrideLookUp,
  LogMode.Diagnostic,
  diagnosticOverrideLookUp,
  LogMode.Production,
  productionOverrideLookup
]);

/// In Production Mode, these events will have an alternative treatment, either
/// alternatively output to a different destination or will not even be exist.
const LookupMap productionOverrideLookup = const LookupMap<Event, Appender>(
    const [Event.DeferredLoadException, Discarder.append]);

/// Returns an Appender for the event given the state of the logger and if any
/// overrides exist for event in the given state.
Appender selectAppender(Event type) {
  LookupMap override = overrideMaps[LoggerState.currentMode];
  Appender appender = override[type];
  if (appender != null) {
    appender = defaultAppender[LoggerState] ?? WebConsole.append;
  }
  return appender;
}

/// Manages the over state of the logger.
class LoggerState {
  static LogMode currentMode = LogMode.Development; // Current Logging model.

  /// Sets the current mode of the logger;
  static set mode(LogMode mode) {
    currentMode = mode;
  }

  static update(Map config) {
    var previousValue = LogMode.values[config['current']];
    var newValue = LogMode.values[config['changeTo']];
    if (currentMode == previousValue && newValue != currentMode) {
      currentMode == newValue;
    } else {
        // Need to msg back it did not happen.
    }
  }
}
