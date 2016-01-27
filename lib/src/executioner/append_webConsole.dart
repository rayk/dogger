library appender.webConsole;

import 'package:js/js.dart';

import 'package:dogger/src/executioner/appender.dart';

/// Manages the state and operations of the WebConsole;
class WebConsole implements Appender{

    List _template = [];
    List _OpenGoups = [];
    List _OpenProfiles = [];
    List _openTimeLists = [];
    List _openTimers = [];

    final Console output = new Console();

    static append(Map entry){


    }
    List get logEntryTemplate => _template;

}

@JS('Console')
class Console {
    external clear();
    external count(String label);
    external log(String entry);
    external dir(Object object);
    external error(String entry);
    external group(String label);
    external groupCollapsed(String label);
    external groupEnd();
    external info(String entry);
    external table(Map table);
    external warn(String entry);
    external profile(String label);
    external profileEnd(String label);
    external timeline(String label);
    external timelineEnd(String label);
    external time(String label);
    external timeEnd(String label);
    external timeStamp(String label);

}

@JS('WorkerGlobalScope')
class WorkerGlobalScope {
   external Console get console;
}