import 'package:BotBinance/BotBinance.dart';

String apiKey = 'zcKC5kyp6HHWjEfCXkNonPudPZDcmHu1ZTJzqCfK3BGc72t4pcAhzvJl2DIRPFVZ';
String apiSecret = 'JYPuuWUAic4uprccwkRothlc81gflI8sRL7xiuAzZDU0PfaCNdmRae07kto6URod';

Future main(List<String> arguments) async {
  var binanceAPI = BinanceAPI(apiKey, apiSecret);

  var symbolOrder = await binanceAPI.getSymbolOrder();
  print(symbolOrder);

  var testNewOrder = await binanceAPI.getTestNewOrder();
  print(symbolOrder);

  var currentOpenOrders = await binanceAPI.getCurrentOpenOrders();
  print(currentOpenOrders);

  var allOrders = await binanceAPI.getAllOrders();
  print(allOrders);

  var orders = await binanceAPI.getOrder();
  print(orders);


  var connectivi = await binanceAPI.getConnectivity();
  print(connectivi);

  var checkServerTime = await binanceAPI.getCheckServerTime();
  print(checkServerTime);


  var exchangeInfo = await binanceAPI.getExchangeInfo();
  print(exchangeInfo);

  var orderBook = await binanceAPI.getOrderBook();
  print(orderBook);

  var order = await binanceAPI.getOrder();
  print(order);

  var account = await binanceAPI.getAccount();
  print(account);

  var avgPrice = await binanceAPI.getAvgPrice();
  print(avgPrice);

}
