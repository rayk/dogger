# Dogger

Externalised logging library, executing within it's own Isolate (WebWorker). The objective is to create uniform 
logging messages. 

This is achieved by creating an abstract which is inline with the context in which a developer writes the
logging statement. 

## Usage

1. The first thing is acquire a reference to the DoggerService. It's singleton to newing it inexpensive.
2. There is enum that allows the selection of one of the logging modes. The dogger decides logging levels from this.
3. Calling logger(async) and passing in a class, function or just a label will return a LogFunction.
4. Using this void function within the established scope will cause a message to sent to the log processor.
5. The processor which is running on a separate Isolate handles all the parsing and construction of the log entry.
6. Which is then routed to the correct appender given the logging mode.
7. The log entry is then appended to to either any number of logs, webConsole, workerConsole, externally, local store. 


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
