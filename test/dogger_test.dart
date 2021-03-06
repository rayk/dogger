// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dogger.test;

import 'dart:isolate';

import 'package:dogger/dogger.dart';
import 'package:test/test.dart';

void main() {
  group('Logger Dogger', () {

    test('Should generate message flat message.', () async {
      TestDog testDog = new TestDog();
      logFunction log;
      DoggerService logService;
      ReceivePort listenToPort = new ReceivePort();

      logService = new DoggerService(LogMode.Diagnostic,
          testPort: listenToPort.sendPort);

      expect(logService, isNotNull);
      expect(logService.isExecutorRunning, isTrue);
      expect(logService.logMode, isNotNull);

      log = await logService.logger(testDog);

      expect(log, equals(new isInstanceOf<logFunction>()));
      expect(logService.isExecutorRunning, isTrue);

      listenToPort.listen(expectAsync((Map message) {
        expect(message.keys.length, equals(10));
      }, count: 1));

      log(Event.Error, msg: 'Unknown');
    });

    test('Should only be returning the same instance all the time.',(){
      DoggerService logService01;
      DoggerService logService02;

      logService01 = new DoggerService(LogMode.Diagnostic);
      logService02 = new DoggerService(LogMode.Diagnostic);
      expect(identical(logService01, logService02), isTrue);
    });


  });
}

class TestDog {}
