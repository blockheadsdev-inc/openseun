import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seunswap/api/data_local_storage.dart';

import '../models/tokens/token.dart';

class SeunSwapApi {
  final String _domain = '167.99.229.54';
  final String _port = '8100';
  final String _network = 'testnet'; // mainnet or testnet?

  LocalData _localData = LocalData();

  final Map<String, String> _headers = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  final _client = http.Client();

  Future<Map> listToken(
    String _walletId,
    String _tokenId,
    int _amount,
    int _priceInTinyBars,
  ) async {
    String _endpoint = '/seunswap/$_network/listToken';
    String _url = "http://$_domain:$_port$_endpoint";
    var _body = """
        {
          "walletId": "$_walletId",
          "tokenId": "$_tokenId",
          "amount": $_amount,
          "priceInTinyBars": $_priceInTinyBars
        }
      """;

    print(_body);

    Map _errorMap = <int, String>{};

    try {
      var _response = await _client.post(
        Uri.parse(_url),
        body: _body,
        headers: _headers,
      );
      var _res = json.decode(_response.body);
      print("seunswapAPI listToken()  $_res");
      return _res;
    } catch (e) {
      _errorMap = {1: '$e'};
      print(e);
      return _errorMap;
    }
  }

  Future<Map> createKeyStore(
    String _accountId,
    String _publicKey,
    String _privateKey,
    String _walletName,
  ) async {
    String _endpoint = '/seunswap/$_network/createKeyStore';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "accountId": "$_accountId",
          "publicKey": "$_publicKey",
          "privateKey": "$_privateKey",
          "walletName": "$_walletName"
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("seunswapAPI createKeyStore() :  $_res");
    return _res;
  }

  Future<Map> updateTokenPrice(
    String _walletId,
    String _walletTokenId,
    int _newPrice,
  ) async {
    String _endpoint = '/seunswap/$_network/updateTokenPrice';
    String _url = "http://$_domain:$_port$_endpoint";
    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "walletId": $_walletId,
          "walletTokenId": $_walletTokenId,
          "newPrice": $_newPrice
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print(_res);
    return _res;
  }

  Future<Map> sellToken(
    String _walletId,
    String _walletTokenId,
    int _amount,
  ) async {
    String _endpoint = '/seunswap/$_network/SellToken';
    String _url = "http://$_domain:$_port$_endpoint";
    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "walletId": $_walletId,
          "walletTokenId": $_walletTokenId,
          "amount": $_amount
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print(_res);
    return _res;
  }

  Future<Map> purchaseToken(
    String _walletId,
    String _walletTokenId,
    int _quantity,
  ) async {
    String _body = """
        {
          "walletId": $_walletId,
          "walletTokenId": $_walletTokenId,
          "quantity": $_quantity
        }
      """;
    print(_body);
    String _endpoint = '/seunswap/$_network/purchaseToken';
    String _url = "http://$_domain:$_port$_endpoint";
    var _response =
        await _client.post(Uri.parse(_url), body: _body, headers: _headers);

    var _res = json.decode(_response.body);
    print(_res);
    return _res;
  }

  Future<Map> fetchTokenPrice(
    String _walletId,
    String _walletTokenId,
  ) async {
    String _endpoint = '/seunswap/$_network/fetchTokenPrice';
    String _url = 'http://$_domain:$_port$_endpoint';
    String _params = """
          walletId=$_walletId
          &
          walletTokenId=$_walletTokenId
      """;
    var _response = await _client.get(Uri.parse("$_url?${_params.trim}"),
        headers: _headers);

    var _res = json.decode(_response.body);
    print(_res);
    return _res;
  }

  Future<Map> fetchTokenBalance(
    String _walletId,
    String _walletTokenId,
  ) async {
    String _endpoint = '/seunswap/$_network/purchaseToken';
    String _url = 'http://$_domain:$_port$_endpoint';
    String _params = """
          walletId=$_walletId
          &
          walletTokenId=$_walletTokenId
      """;
    var _response = await _client.get(Uri.parse("$_url?${_params.trim}"),
        headers: _headers);

    var _res = json.decode(_response.body);
    print(_res);
    return _res;
  }

  Future<List<Token>> fetchListedTokens() async {
    String _endpoint = '/seunswap/$_network/fetchListedTokens';
    String _url = 'http://$_domain:$_port$_endpoint';

    var _response = await _client.get(Uri.parse(_url), headers: _headers);

    var _jsonData = json.decode(_response.body);
    print(_jsonData);
    List<Token> tokens = [];

    for (var t in _jsonData) {
      Token token = Token(t["walletTokenId"], t["walletId"], t["tokenId"],
          t["tokenName"], t["price"], t["balance"]);
      // print("Token: $token");
      tokens.add(token);
    }
    // print("ALl Tokens: $tokens");
    return tokens;
  }

  Future<List<Token>> fetchOwnedTokens() async {
    String _endpoint = '/seunswap/$_network/fetchListedTokens';
    String _url = 'http://$_domain:$_port$_endpoint';
    String _walletFromLocal =
        await _localData.getStringValues("walletId") ?? '0';
    var _response = await _client.get(Uri.parse(_url), headers: _headers);

    var _jsonData = json.decode(_response.body);
    print(_jsonData);
    List<Token> tokens = [];

    for (var t in _jsonData) {
      if (_walletFromLocal == t["walletId"]) {
        Token token = Token(t["walletTokenId"], t["walletId"], t["tokenId"],
            t["tokenName"], t["price"], t["balance"]);
        // print("Token: $token");
        tokens.add(token);
      } else {}
    }

    print("Owned Tokens: $tokens");
    return tokens;
  }
}
