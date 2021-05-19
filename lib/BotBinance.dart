import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:swiss_knife/swiss_knife.dart';

class BinanceAPI {
  final String _apiKey;
  final String _apiSecret;

  final String apiUrl;

  BinanceAPI(this._apiKey, this._apiSecret,
      {this.apiUrl = 'https://api.binance.com/api/v3/'});

  Future<HttpResponse> doBinanceAccontRequest(String method, String requestPath,
      [dynamic body]) async {

    var timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String,String> parameters = {
      'recvWindow': '5000',
      'timestamp': '$timeStamp'
    };

    var sign = _signRequest(parameters);

    parameters['signature'] = sign ;

    var client = HttpClient(apiUrl)
      ..requestHeadersBuilder = (clt, url) => {
        'X-MBX-APIKEY': _apiKey
      }
    ;

    var response = await client.request(getHttpMethod(method)!, requestPath, parameters: parameters);
    return response;
  }

  String _signRequest(Map<String,String> parameters) {
    if (parameters.containsKey('signature')) {
      throw StateError('Already signed: $parameters');
    }
    
    var queryStringPreSign = encodeQueryString(parameters);
    var hmacSha256 = Hmac(sha256, utf8.encode(_apiSecret));
    
    var msg = utf8.encode(queryStringPreSign);
    var signBytes = hmacSha256.convert( msg ).bytes;
    
    var signHex = signBytes.map( (b) => b.toRadixString(16).padLeft(2,'0') ).join('') ;
    return signHex ;
  }

  Future<String?> getConnectivity() async {
    var response = await doBinanceAccontRequest('GET', 'ping');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getCheckServerTime() async {
    var response = await doBinanceAccontRequest('GET', 'time');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    var timevalue2 = response.accessTime.toString();

    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getExchangeInfo() async {
    var response = await doBinanceAccontRequest('GET', 'exchangeInfo');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getOrderBook() async {
    var response = await doBinanceAccontRequest('GET', 'depth');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getOrder() async {
    var response = await doBinanceAccontRequest('GET', 'order');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getOpenOrders() async {
    var response = await doBinanceAccontRequest('GET', 'openOrders');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getAccount() async {
    var response = await doBinanceAccontRequest('GET', 'account');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    var json = response.json ;
    var accountType = json['accountType'];

    return response.bodyAsString;
  }

}