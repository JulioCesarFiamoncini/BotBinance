import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mercury_client/mercury_client.dart';

class BinanceAPI {
  final String _apiSecretBase64;
  final String _apiKey;
  final String _apiPass;
  final String apiUrl;


  BinanceAPI(this._apiSecretBase64, this._apiKey, this._apiPass,
      {this.apiUrl = 'https://api.binance.com/'});

  String _signMessage(
      String secretBase64, int timestamp, String method, String requestPath,
      [String? body]) {
    method = method.toUpperCase();

    var key = base64.decode(secretBase64);
    var hmacSha256 = Hmac(sha256, key);

    var msg = '$timestamp$requestPath';
    if (body != null) msg += body;

    var msgBytes = utf8.encode(msg);
  //  msgBytes=msgBytes+hmacSha256;

    var sign = hmacSha256
        .convert(msgBytes)
        .bytes;

    var signBase64 = base64.encode(sign);

    return signBase64;
  }

  Future<HttpResponse> doBinanceRequest(String method, String requestPath,
      [dynamic body]) async {
    // var timeStamp = (DateTime
    //     .now()
    //     .millisecondsSinceEpoch ~/ 1000);

    var timeStamp = (DateTime
        .now()
        .millisecondsSinceEpoch);

    var sign = _signMessage(_apiSecretBase64, timeStamp, method, requestPath);


    var client = HttpClient(apiUrl)
      ..requestHeadersBuilder = (clt, url) => {
        'X-MBX-APIKEY': _apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

    var response = await client.request(getHttpMethod(method)!, requestPath);
    return response;
  }

  Future<HttpResponse> doBinanceAccontRequest(String method, String requestPath,
      [dynamic body]) async {

    var timeStamp = (DateTime
        .now()
        .millisecondsSinceEpoch);



    var key = base64.decode(_apiSecretBase64);
    var hmacSha256 = Hmac(sha256, key);

    // var msg = '$timestamp$method$requestPath';
    List<String> list = ["recvWindow=5000","timestamp=$timeStamp"];
    var msg = list.join('&');

    if (body != null) msg += body;

    var msgBytes = utf8.encode(msg);

    var sign = hmacSha256.convert(msgBytes).bytes;

    var signBase64 = base64.encode(sign);

    Map<String, String> map = { 'signature': '$signBase64' };

     var client = HttpClient(apiUrl)
      ..clientRequester.buildQueryString(map)
      ..requestHeadersBuilder = (clt, url) => {
        'X-MBX-APIKEY': _apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

    var response = await client.request(getHttpMethod(method)!, requestPath);
    return response;
  }


  Future<String?> getConnectivity() async {
    var response = await doBinanceRequest('GET', '/api/v3/ping');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getCheckServerTime() async {
    var response = await doBinanceRequest('GET', '/api/v3/time');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    var timevalue2 = response.accessTime.toString();

    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getExchangeInfo() async {
    var response = await doBinanceRequest('GET', '/api/v3/exchangeInfo');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getOrderBook() async {
    var response = await doBinanceRequest('GET', '/api/v3/depth');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getOrder() async {
    var response = await doBinanceRequest('GET', '/api/v3/order');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getOpenOrders() async {
    var response = await doBinanceRequest('GET', '/api/v3/openOrders');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getAccount() async {


    var response = await doBinanceAccontRequest('GET', 'api/v3/account');
   // if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }


}