// Configuration lookup for dogger, all parameters are kept here out of the code.
library configuration;

import 'package:lookup_map/lookup_map.dart';

/// Main lookup to return function for the parameter you want.
const LookupMap configLookUp = const LookupMap(const [
  Parameter.appKey,
  'd85e8385-b85b-4ca4-8e0c-ad24af7c4f7b',
  Parameter.appNamespace,
  'www.goalongoal.com',
  Parameter.appVersion,
  "0.0.3",
  Parameter.fireBaseToken,
  "REULCMw38EXAmkyYF2TcwNwsCNSVJbYOLKQGMihT",
  Parameter.fireBaseUrl,
  'https://goaldevelopment.firebaseio.com/',
  Parameter.isolatePackage,
  "package:darrdex/dexverse/",
  Parameter.isolatePath,
  'package:dardex/dexverse/dexverse.dart',
  Parameter.loggingExecutor,
  '/Users/rayk/Projects/dogger/lib/src/executioner/core.dart',
  Parameter.testValue,
  'Used to test config function.',
  Parameter.timeoutIsolateConfig,
  500,
  Parameter.timeSkewUrl,
  '/.info/serverTimeOffset',
]);

Map runtimeLookup;

/// Returns a value associated with a parameter key.
dynamic frConfig(Parameter configurationParameter) {
  var configValue = configLookUp[configurationParameter];
  if (configValue == null) {
    configValue = runtimeLookup[configurationParameter];
  }
  return configValue;
}

/// Adds a volatile configuration value for configuration lookup. Will not
/// overwrite the constant values.
void toConfig(Parameter runtimeParameter, Object value) {
  if (runtimeLookup == null) {
    runtimeLookup = new Map();
  }
  runtimeLookup[runtimeParameter] = value;
}

/// Enumeration of the configuration parameters
enum Parameter {
  appKey,
  appNamespace,
  appVersion,
  fireBaseToken,
  fireBaseUrl,
  isolatePackage,
  isolatePath,
  loggingExecutor,
  logModeCurrent,
  logService,
  testValue,
  timeoutIsolateConfig,
  timeSkewUrl,
}
