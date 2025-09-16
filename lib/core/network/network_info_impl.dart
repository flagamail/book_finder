import 'package:book_finder/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/app_logger.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    var isConnected = !result.contains(ConnectivityResult.none);
    appLogger.d('Connectivity has result $result is connected $isConnected');
    return isConnected;
  }
}
