import 'package:flutter/material.dart';

import '../api/data_local_storage.dart';
import '../api/seunswap_api.dart';

class ListCoinForm extends StatefulWidget {
  final TabController tabController;
  const ListCoinForm({Key? key, required this.tabController}) : super(key: key);

  @override
  State<ListCoinForm> createState() => _ListCoinFormState();
}

class _ListCoinFormState extends State<ListCoinForm> {
  late TextEditingController _walletIdTextField;
  late TextEditingController _tokenIdTextField;
  late TextEditingController _amountTextField;
  late TextEditingController _hbarAmountTextField;

  int _priceInTinyBarsTextField = 0;

  final _createTokenFormKey = GlobalKey<FormState>();

  final LocalData _dataStorage = LocalData();

  SeunSwapApi _seunSwapApi = SeunSwapApi();

  @override
  void initState() {
    _walletIdTextField = TextEditingController();
    _tokenIdTextField = TextEditingController();
    _amountTextField = TextEditingController();
    _hbarAmountTextField = TextEditingController();

    _getWalletIdAndDisplay();

    super.initState();
  }

  @override
  void dispose() {
    _walletIdTextField.dispose();
    _tokenIdTextField.dispose();
    _amountTextField.dispose();
    _hbarAmountTextField.dispose();

    super.dispose();
  }

  TextStyle _textStyle(double _size) {
    return TextStyle(
      fontSize: _size,
    );
  }

  InputDecoration _decoration(String _label) {
    return InputDecoration(
      labelText: _label,
    );
  }

  double hbarToTinyBar(double _hbar) {
    double _r = _hbar * 100000000;
    return _r;
  }

  _getWalletIdAndDisplay() async {
    String _data = await _dataStorage.getStringValues("walletId") ?? '0';
    if (_data != '' && _data != '0') {
      _walletIdTextField.text = _data;
    }
  }

  Future<Map> _submitListToken() async {
    var _result = await _seunSwapApi.listToken(
      _walletIdTextField.text,
      _tokenIdTextField.text,
      int.parse(_amountTextField.text),
      _priceInTinyBarsTextField,
    );
    return _result;
  }

  void _submitButtonLogic() async {
    bool _isWalletId = false;
    String? _data = await _dataStorage.getStringValues("walletId");
    if (_data != null) {
      _isWalletId = true;
    }
    if (!_isWalletId) {
      _firstStartDialog();
    } else {
      if (!_ifInputsEmpty()) {
        String _hbar = _hbarAmountTextField.text;
        double _tinyBars = hbarToTinyBar(double.parse(_hbar));
        // _displayTinyBars(_tinyBars.toString());
        setState(() {
          _priceInTinyBarsTextField = _tinyBars.toInt();
        });
        print("TinyBars Conversion :  $_priceInTinyBarsTextField");
        _displaySnackMessage('Creating Your Token... Please Wait');

        Map _res = await _submitListToken();

        print('_submitButtonLogic()  :   $_res');

        if (_res['status'] != 500) {
          _displaySnackMessage('Your Token Id is: ${_res['walletTokenId']}');
        } else {
          _displaySnackMessage(
              'Something went wrong. status: ${_res['status']}  error: ${_res['error']}');
        }
      }
    }
  }

  bool _ifInputsEmpty() {
    if (_tokenIdTextField.text == '' || _amountTextField.text == '') {
      return true;
    } else {
      return false;
    }
  }

  void _firstStartDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('SEUNSwap Tip'),
            content: const Text('Please Import Wallet First'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.tabController.index = 3;
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('Okay'),
              )
            ],
          );
        });
  }

  void _displaySnackMessage(String _message) {
    if (_message != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 8.0, right: 8.0),
      child: Container(
        height: 525,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    spreadRadius: -2.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Create Token",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 33,
                    height: 1.3,
                    letterSpacing: 0.6,
                    // fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 10),
              child: Form(
                key: _createTokenFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _walletIdTextField,
                      decoration: _decoration('Wallet ID'),
                      style: _textStyle(24),
                    ),
                    TextFormField(
                      controller: _tokenIdTextField,
                      decoration: _decoration('Token ID'),
                      style: _textStyle(24),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _amountTextField,
                      decoration: _decoration('Amount'),
                      style: _textStyle(24),
                      keyboardType: TextInputType.number,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _hbarAmountTextField,
                          decoration: InputDecoration(
                            labelText: "hbar",
                            suffixIcon: GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                'assets/hedera-hashgraph.png',
                                width: 70.0,
                              ),
                            ),
                          ),
                          style: _textStyle(24),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       _priceInTinyBars,
                    //       style: _textStyle(40),
                    //     ),
                    //     // Text(
                    //     //   'Amount in Tiny Bars',
                    //     //   textAlign: TextAlign.right,
                    //     //   style: _textStyle(24),
                    //     // ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 300,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                )),
                            onPressed: () async {
                              _submitButtonLogic();
                            },
                            child: const Text(
                              "Create Token",
                              style: TextStyle(fontSize: 30),
                            ),
                            // style: ButtonStyle(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
