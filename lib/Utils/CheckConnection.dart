import 'package:connectivity/connectivity.dart';

Future<bool> connection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("conRes M = $connectivityResult");

    return Future.value(true);
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("conRes W= $connectivityResult");

    return Future.value(true);
  } else {
    print("conRes = $connectivityResult");

    return Future.value(false);
    // Navigator.push(context,
    //         MaterialPageRoute(builder: (BuildContext context) => OfflineUI()))
    //     .then((value) {
    //   print(".then is ok");
    //   // getData();
    // });
  }
}
