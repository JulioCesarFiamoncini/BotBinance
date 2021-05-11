import 'package:BotBinance/BotBinance.dart';

String apiSecretBase64 = 'JYPuuWUAic4uprccwkRothlc81gflI8sRL7xiuAzZDU0PfaCNdmRae07kto6URod';
String apiKey = 'zcKC5kyp6HHWjEfCXkNonPudPZDcmHu1ZTJzqCfK3BGc72t4pcAhzvJl2DIRPFVZ';
String apiPass = 'online78MD%';

//https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md#check-server-time

Future main(List<String> arguments) async {
  var binanceAPI = BinanceAPI(apiSecretBase64, apiKey, apiPass);

  var connectivi = await binanceAPI.getConnectivity();
  print(connectivi);

  var checkServerTime = await binanceAPI.getCheckServerTime();
  print(checkServerTime);


}
