import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:swiss_knife/swiss_knife.dart';

class BinanceAPI {
  final String _apiKey;
  final String _apiSecret;

  final String apiUrl;
  final Map<String,String> otherParameters = {'': ''};

  BinanceAPI(this._apiKey, this._apiSecret,
      {this.apiUrl = 'https://api.binance.com/api/v3/'});

  Future<HttpResponse> doBinanceRequest(String method, String requestPath, [Map<String,String>? parameters, dynamic body]
      ) async {

    var client = HttpClient(apiUrl)
      ..requestHeadersBuilder = (clt, url) => {
      }
    ;

    var response = await client.request(getHttpMethod(method)!, requestPath, parameters: parameters);
    return response;
  }


  Map<String,String> getParameterSing() {
    var timeStamp = DateTime
        .now()
        .millisecondsSinceEpoch;

    Map<String, String> parameters = {
      'recvWindow': '5000',
      'timestamp': '$timeStamp'
    };

    return parameters;
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


  Future<HttpResponse> doBinanceSignRequest(String method, String requestPath,Map<String,String> parametersSign,
  Map<String,String> otherParameters, [dynamic body]) async {

    var sign = _signRequest(parametersSign);

    parametersSign['signature'] = sign;

    var client = HttpClient(apiUrl)
      ..requestHeadersBuilder = (clt, url) => {
        'X-MBX-APIKEY': _apiKey
      }
    ;

    if (otherParameters.isNotEmpty) {
      parametersSign.addAll(otherParameters);
    }

    //var response = await client.request(getHttpMethod(method)!, requestPath, parameters: unionMap);
    var response = await client.request(getHttpMethod(method)!, requestPath, parameters: parametersSign);
    return response;
  }


  Future<String?> getConnectivity() async {
    var response = await doBinanceRequest('GET', 'ping');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getCheckServerTime() async {
    var response = await doBinanceRequest('GET', 'time');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    var timevalue2 = response.accessTime.toString();

    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getExchangeInfo() async {
    var response = await doBinanceRequest('GET', 'exchangeInfo');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    var json = response.json ;
    var accountType = json['accountType'];

    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> getOrderBook() async {
    var response = await doBinanceSignRequest('GET', 'depth',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }


  Future<String?> getOpenOrders() async {
    var response = await doBinanceSignRequest('GET', 'openOrders',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    return response.bodyAsString;
  }

  Future<String?> getAccount() async {
    var response = await doBinanceSignRequest('GET', 'account',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    var json = response.json ;
    var accountType = json['accountType'];

    return response.bodyAsString;
  }

  Future<String?> getAvgPrice() async {
    otherParameters.addAll({'symbol': 'LTCBTC'});

    var response = await doBinanceRequest('GET', 'avgPrice', otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;

    var json = response.json ;
    var accountType = json['accountType'];

    return response.bodyAsString;
  }



  Future<String?> getTradersList() async {
    var response = await doBinanceRequest('GET', 'trades');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
    // var list = response.json as List;
    // return list.cast<Map<String, dynamic>>();
  }

  Future<String?> get24hrTickerPrice() async {
    var response = await doBinanceRequest('GET', 'ticker/24hr');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> getSymbolPrice() async {
    var response = await doBinanceRequest('GET', 'ticker/price');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> getSymbolOrder() async {
    var response = await doBinanceRequest('GET', 'ticker/bookTicker');
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> getTestNewOrder() async {
    var response = await doBinanceSignRequest('GET', 'order/test',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> getCurrentOpenOrders() async {
    var response = await doBinanceSignRequest('GET', 'openOrders',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> getAllOrders() async {
    var response = await doBinanceSignRequest('GET', 'allOrders',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> getOrder() async {
    otherParameters.addAll({'symbol': 'LTCBTC'});
    var response = await doBinanceSignRequest('GET', 'order',getParameterSing(),otherParameters);
    if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }

  Future<String?> sendTestNewOrder () async {
    Map<String,String> testParameters = {'symbol': 'LTCBTC',
      'side': 'SELL',
      'type': 'MARKET'};
    var response = await doBinanceSignRequest('POST', 'order/test',getParameterSing(),testParameters);
    //if (response.isNotOK || !response.isBodyTypeJSON) return null;
    return response.bodyAsString;
  }



  }