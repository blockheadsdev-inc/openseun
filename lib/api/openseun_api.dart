import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/project.dart';

class OpenSeunApi {
  final String _domain = '167.99.229.54';
  final String _port = '8200';
  final String _network = 'testnet'; // mainnet or testnet?

  // final LocalData _localData = LocalData();

  final Map<String, String> _headers = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  final _client = http.Client();

  Future<Map> createInvestorKeyStore(
    String _investorId,
    String _accountId,
    String _publicKey,
    String _privateKey,
    String _walletName,
  ) async {
    String _endpoint = '/openseun/$_network/wallet/createInvestorKeystore';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "projectId": "$_investorId",
          "accountId": "$_accountId",
          "publicKey": "$_publicKey",
          "privateKey": "$_privateKey",
          "walletName": "$_walletName"
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI createProjectKeyStore() :  $_res");
    return _res;
  }

  Future<Map> createProjectKeyStore(
    String _projectId,
    String _accountId,
    String _publicKey,
    String _privateKey,
    String _walletName,
  ) async {
    String _endpoint = '/openseun/$_network/wallet/createProjectKeystore';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "projectId": "$_projectId",
          "accountId": "$_accountId",
          "publicKey": "$_publicKey",
          "privateKey": "$_privateKey",
          "walletName": "$_walletName"
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI createProjectKeyStore() :  $_res");
    return _res;
  }

  Future<List<Project>> fetchAllProjects() async {
    String _endpoint = '/openseun/$_network/project/fetchAllProjects';
    String _url = 'http://$_domain:$_port$_endpoint';

    var _response = await _client.get(Uri.parse(_url), headers: _headers);

    var _jsonData = json.decode(_response.body);
    print(_jsonData);
    List<Project> projects = [];

    for (var p in _jsonData) {
      Project project = Project(id: p["projectId"], name: p["projectName"]);
      // print("Project: $project");
      projects.add(project);
    }
    // print("ALl Projects: $projects");
    return projects;
  }

  Future<Map> fetchProjectWallet(
    String _projectId,
    String _walletId,
  ) async {
    String _endpoint = '/openseun/$_network/wallet/fetchProjectWallet';
    String _url = 'http://$_domain:$_port$_endpoint';
    String _body = """
    {
          "projectId": "$_projectId",
          "walletId": "$_walletId"
    }
      """;
    // print(_body);

    Map _errorMap = <int, String>{};

    try {
      var _response = await _client.post(
        Uri.parse(_url),
        body: _body,
        headers: _headers,
      );
      var _res = json.decode(_response.body);
      print("openseunAPI fetchProjectWallet()  $_res");
      return _res;
    } catch (e) {
      _errorMap = {1: '$e'};
      print(e);
      return _errorMap;
    }
  }

  Future<Map> fetchInvestorWallet(
    String _investorId,
    String _walletId,
  ) async {
    String _endpoint = '/openseun/$_network/wallet/fetchInvestorWallet';
    String _url = 'http://$_domain:$_port$_endpoint';
    String _body = """
    {
          "investorId": "$_investorId",
          "walletId": "$_walletId"
    }
      """;
    // print(_body);

    Map _errorMap = <int, String>{};

    try {
      var _response = await _client.post(
        Uri.parse(_url),
        body: _body,
        headers: _headers,
      );
      var _res = json.decode(_response.body);
      print("openseunAPI fetchInvestorWallet()  $_res");
      return _res;
    } catch (e) {
      _errorMap = {1: '$e'};
      print(e);
      return _errorMap;
    }
  }

  Future<Map> addInvestor(
      String _name, String location, String _category) async {
    String _endpoint = '/openseun/$_network/investor/addInvestor';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "name": "$_name",
          "location": "$location",
          "category": "$_category",
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI addInvestor() :  $_res");
    return _res;
  }

  Future<Map> fetchInvestorInfo(String investorId) async {
    String _endpoint = '/openseun/$_network/investor/fetchInvestorInfo';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "investorId": "$investorId",
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI fetchInvestorInfo() :  $_res");
    return _res;
  }

  Future<Map> purchaseCarbonCredits(String _name, int _offset) async {
    String _endpoint = '/openseun/$_network/investor/purchaseCarbonCredits';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "investorId": "$_name",
          "offset": $_offset,
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI purchaseCarbonCredits() :  $_res");
    return _res;
  }

  Future<Map> chooseOffsetOption(
    String investorId,
    String _projectId,
    double _offsetQuantity,
    double _offsetPrice,
  ) async {
    String _endpoint = '/openseun/$_network/investor/chooseOffsetOption';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "investorId": "$investorId",
          "offsetOption": {
            "projectId": "$_projectId",
            "offsetQuantity": $_offsetQuantity,
            "offsetPrice": $_offsetPrice
          }
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI chooseOffsetOption() :  $_res");
    return _res;
  }

  Future<Map> listProject(String _name, String _description, String location,
      double _estimatedReductions, String _category, String _type) async {
    String _endpoint = '/openseun/$_network/project/listProject';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "name": "$_name",
          "description": "$_description",
          "location": "$location",
          "estimatedReductions": $_estimatedReductions,
          "category": "$_category",
          "type": "$_type"
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI listProject() :  $_res");
    return _res;
  }

  Future<Map> activateProject(String _projectId) async {
    String _endpoint = '/openseun/$_network/project/activateProject';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "projectId": "$_projectId",
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI activateProject() :  $_res");
    return _res;
  }

  Future<Map> fetchProjectData(String _projectId) async {
    String _endpoint = '/openseun/$_network/project/fetchProjectData';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "projectId": "$_projectId",
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI fetchProjectData() :  $_res");
    return _res;
  }

  Future<Map> deactivateProject(String _projectId) async {
    String _endpoint = '/openseun/$_network/project/deactivateProject';
    String _url = "http://$_domain:$_port$_endpoint";

    var _response = await _client.post(Uri.parse(_url),
        body: """
        {
          "projectId": "$_projectId",
        }
      """,
        headers: _headers);

    var _res = json.decode(_response.body);
    print("openseunAPI deactivateProject() :  $_res");
    return _res;
  }
}
