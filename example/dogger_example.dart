// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dogger.example;

import 'package:dogger/dogger.dart';
import 'dart:isolate';

class TestDog {}

main()async{

    TestDog testDog = new TestDog();
    logFunction log;
    DoggerService logService;
    ReceivePort listenToPort = new ReceivePort();

    logService =
    new DoggerService(LogMode.Diagnostic, testPort: listenToPort);

    log = await logService.logger(testDog);

}

