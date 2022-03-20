import 'package:flutter/material.dart';
import 'package:seunswap/api/seunswap_api.dart';
import 'package:seunswap/models/tokens/h2o_bond.dart';
import 'package:seunswap/models/tokens/hbar.dart';

import '../api/data_local_storage.dart';

class SwapTokenForm extends StatefulWidget {
  final TabController tabController;
  const SwapTokenForm({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<SwapTokenForm> createState() => _SwapTokenFormState();
}

class _SwapTokenFormState extends State<SwapTokenForm> {
  late String tokenWalletId;
  late TextEditingController _tokenId;
  late TextEditingController _amount1;
  late TextEditingController _amount2;

  late Widget _image1;
  late Widget _image2;

  final TokenHbar _tokenHbar = TokenHbar();
  final TokenH20Bond _tokenH20Bond = TokenH20Bond();

  final SeunSwapApi _seunSwapApi = SeunSwapApi();
  final LocalData _dataStorage = LocalData();

  final _swapFormKey = GlobalKey<FormState>();

  int _hbarFieldPosition = 0;

  @override
  void initState() {
    _tokenId = TextEditingController();
    _amount1 = TextEditingController();
    _amount2 = TextEditingController();

    _image1 = _tokenHbar.tokenIcon;
    _image2 = _tokenH20Bond.tokenIcon;

    // _initGetTokenId();
    super.initState();
  }

  @override
  void dispose() {
    _tokenId.dispose();
    _amount1.dispose();
    _amount2.dispose();
    super.dispose();
  }

  void _initGetTokenId() async {
    String? _tid = (await _dataStorage.getSelectedTokenId())!;
    String? _twid = (await _dataStorage.getSelectedTokenWalletId())!;
    _amount1.clear();
    _amount2.clear();
    setState(() {
      _tokenId.text = _tid;
      tokenWalletId = _twid;
    });
  }

  Future<void> _getTokenId() async {
    String? _tid = (await _dataStorage.getSelectedTokenId())!;
    String? _twid = (await _dataStorage.getSelectedTokenWalletId())!;
    if (mounted) {
      setState(() {
        _tokenId.text = _tid;
        tokenWalletId = _twid;
      });
    }
  }

  InputDecoration _decoration(String _label, [String? _hint]) {
    return InputDecoration(
      labelText: _label,
      hintText: _hint,
    );
  }

  TextStyle _textStyle(double _size) {
    return TextStyle(
      fontSize: _size,
    );
  }

  String removeDecimalZeroFormat(double n) {
    // return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");
    return n.toString().replaceAll(regex, '');
  }

  // Object? selectedValue = 1;

  void _swapValues() {
    String _s1 = _amount1.text;
    String _s2 = _amount2.text;

    if (_s1 != '' && _s2 != '') {
      if (_s1 != '0' && _s2 != '0') {
        double _x1 = double.parse(_s1);
        double _x2 = double.parse(_s2);
        setState(() {
          _amount1.text = removeDecimalZeroFormat(_x2);
          _amount2.text = removeDecimalZeroFormat(_x1);
          _swapIcons();
          _swapHbarPos();
        });
      }
    }
  }

  void _swapHbarPos() {
    if (_hbarFieldPosition < 1) {
      _hbarFieldPosition = 1;
    } else {
      _hbarFieldPosition = 0;
    }
  }

  void _swapIcons() {
    Widget _i1 = _image1;
    Widget _i2 = _image2;
    setState(() {
      _image1 = _i2;
      _image2 = _i1;
    });
  }

  bool _ifInputsEmpty() {
    if (_amount1.text == '' || _amount2.text == '') {
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

  void _swapSubmit() {
    if (_hbarFieldPosition < 1) {
      _seunSwapApi.purchaseToken(_tokenId.text, tokenWalletId, 0);
    } else {}
  }

  void _returnSubmitButtonLogic() async {
    bool _isWalletId = false;
    String? _data = await _dataStorage.getStringValues("walletId");

    if (_data != null) {
      if (_data.isNotEmpty) {
        _isWalletId = true;
      } else {
        _isWalletId = false;
      }
    }
    if (!_isWalletId) {
      _firstStartDialog();
    } else {
      _swapSubmit();
      // if (_res['status'] != 500) {
      //   _displaySnackMessage('Your Token Id is: ${_res['walletTokenId']}');
      // } else {
      //   _displaySnackMessage(
      //       'Something went wrong. status: ${_res['status']}  error: ${_res['error']}');
      // }
    }
  }

  void _displaySnackMessage(String _message) {
    if (_message != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // _initGetTokenId();
    // _tokenId.clear();
    _getTokenId();
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 8.0, right: 8.0),
      child: Container(
        height: 460,
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
        child: Form(
          key: _swapFormKey,
          child: Column(
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
                    "Swap Token",
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
              // _buildCoinsDropDown(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Token ID",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 250.0,
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _tokenId,
                          keyboardType: TextInputType.number,
                          style: _textStyle(30),
                          decoration: InputDecoration(
                            // enabled: false,
                            hintText: "0.0.0",
                            suffixIcon: GestureDetector(
                              onTap: () {},
                              child: _tokenH20Bond.tokenIcon,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 18.0, right: 18.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFormField(
                            controller: _amount1,
                            keyboardType: TextInputType.number,
                            style: _textStyle(40),
                            decoration: InputDecoration(
                              hintText: "0",
                              suffixIcon: GestureDetector(
                                onTap: () {},
                                child: _image1,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _amount2,
                            keyboardType: TextInputType.number,
                            style: _textStyle(40),
                            decoration: InputDecoration(
                              hintText: "0",
                              suffixIcon: GestureDetector(
                                onTap: () {},
                                child: _image2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// V   Swap Button   V  ///
                    Container(
                      // color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                              // height: 20,
                              // width: 100,
                              ),
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: MaterialButton(
                              // height: 20,
                              // minWidth: 20,
                              onPressed: () {
                                _swapValues();
                              },
                              splashColor: Colors.blue[200],
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.swap_vert_circle_rounded,
                                size: 130,
                                color: Colors.blue,
                                // color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              /// V   Submit Button   V ///
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onPressed: () {
                        _returnSubmitButtonLogic();
                      },
                      child: const Text(
                        "Submit",
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
    );
  }
}
