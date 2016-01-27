/// Routes the logEntry to the correct appender given the current logging mode
/// and the message type.
library router;

import 'package:dogger/src/config/message_types.dart';
import 'package:lookup_map/lookup_map.dart';
import 'package:dogger/src/executioner/append_console.dart';
import 'package:dogger/src/executioner/append_storage.dart';
import 'package:dogger/src/executioner/append_webConsole.dart';


class EntryRouter{

    static void route(){

    }
}