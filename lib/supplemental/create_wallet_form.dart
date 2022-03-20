import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seunswap/api/data_local_storage.dart';
import 'package:seunswap/api/seunswap_api.dart';
import 'package:seunswap/models/wallet_class.dart';

class CreateWalletForm extends StatefulWidget {
  const CreateWalletForm({Key? key}) : super(key: key);

  @override
  State<CreateWalletForm> createState() => _CreateWalletFormState();
}

class _CreateWalletFormState extends State<CreateWalletForm> {
  late TextEditingController _createKeyAccountId;
  late TextEditingController _createKeyPublic;
  late TextEditingController _createKeyPrivate;
  late TextEditingController _createWalletName;
  late TextEditingController _displayWalletId;
  late TextEditingController _importWalletIdController;

  final Key _stackKey = GlobalKey();
  final Key _importWalletIdKey = GlobalKey<FormState>();
  final Key _createWalletFormKey = GlobalKey<FormState>();

  late bool _switchBuildForm;
  late bool _switchChooseImportMethod;
  late bool _switchImportWalletId;
  late bool _switchImportPubPrivKeys;
  late bool _switchWalletImported;
  late bool _switchPageImportById;

  final LocalData _dataStorage = LocalData();
  final SeunSwapApi _seunSwapApi = SeunSwapApi();
  Wallet wallet = Wallet('', '', '', '');

  int _stackIndex = 1;

  @override
  void initState() {
    _createKeyAccountId = TextEditingController();
    _createKeyPublic = TextEditingController();
    _createKeyPrivate = TextEditingController();
    _createWalletName = TextEditingController();
    _displayWalletId = TextEditingController();
    _importWalletIdController = TextEditingController();

    _switchBuildForm = false;
    _switchChooseImportMethod = true;
    _switchImportWalletId = false;
    _switchImportPubPrivKeys = false;
    _switchWalletImported = false;
    _switchPageImportById = false;

    // Check shared_prefs for data, if true, display data in text fields
    _initWalletData();

    // _stackController(_stackIndex);
    // _stackKey = 0;

    super.initState();
  }

  @override
  void dispose() {
    _createKeyAccountId.dispose();
    _createKeyPublic.dispose();
    _createKeyPrivate.dispose();
    _createWalletName.dispose();
    _displayWalletId.dispose();
    _importWalletIdController.dispose();

    super.dispose();
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

  final double _messageHeight = 300.0;
  final double _messageWidth = 340.0;

  BoxDecoration _messageStackDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 9.0,
          spreadRadius: 2.0,
          offset: Offset(2.0, 3.0),
        ),
      ],
    );
  }

  Widget _backButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _stackIndex = 1;
        });
      },
      icon: Icon(
        Icons.arrow_back,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  // Option to choose import method
  Widget _chooseImportMethod() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - _messageHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: _messageHeight,
              maxWidth: _messageWidth,
            ),
            height: _messageHeight,
            width: _messageWidth,
            decoration: _messageStackDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Choose Import Method",
                  style: TextStyle(fontSize: 22),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 240,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                        onPressed: () {
                          setState(() {
                            _stackIndex = 0;
                          });
                        },
                        child: const Center(
                            child: Text('Import Public/Private Keys')),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 240,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                        onPressed: () {
                          setState(() {
                            _stackIndex = 5;
                          });
                        },
                        child: const Center(
                            child: Text('Import With SEUNswap Wallet Id')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // import pasting WalletId
  Widget _importWalletId() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - _messageHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: _messageHeight,
              maxWidth: _messageWidth,
            ),
            decoration: _messageStackDecoration(),
            height: _messageHeight,
            width: _messageWidth,
            child: Center(
              child: Text('Import Wallet with ID'),
            ),
          ),
        ],
      ),
    );
  }

  // import with pub/priv key
  Widget _importPubPrivKeys() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - _messageHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: _messageHeight,
              maxWidth: _messageWidth,
            ),
            decoration: _messageStackDecoration(),
            height: _messageHeight,
            width: _messageWidth,
            child: Center(
              child: Text('Import Wallet with KEYS'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageWalletImported() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - _messageHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: _messageHeight,
              maxWidth: _messageWidth,
            ),
            decoration: _messageStackDecoration(),
            height: _messageHeight,
            width: _messageWidth,
            child: Center(
              child: Text('Wallet Imported!'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletImportId() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 8.0, right: 8.0),
      child: Container(
        // height: 520,
        height: 370,
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
          key: _importWalletIdKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
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
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.c,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft, child: _backButton()),
                    // Align(alignment: Alignment.topRight, child: ,
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Center(
                        child: Text(
                          "Import Wallet",
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 18.0, right: 18.0, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      controller: _importWalletIdController,
                      decoration: _decoration('SEUNswap Wallet ID', ''),
                      style: _textStyle(24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _generateCreateButton(_submitWalletIdButtonLogic),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wallet has been Removed')));
                  await _dataStorage.removeAll();
                  _clearWalletDisplayData();
                  _disableSubmitIfId();
                  setState(() {
                    _stackIndex = 1;
                  });
                },
                child: const Text("Remove data"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageStack() {
    return Stack(
      key: _stackKey,
      alignment: AlignmentDirectional.center,
      children: [
        if (_switchBuildForm) _buildForm(),
        if (_switchChooseImportMethod) _chooseImportMethod(),
        if (_switchImportWalletId) _importWalletId(),
        if (_switchImportPubPrivKeys) _importPubPrivKeys(),
        if (_switchWalletImported) _messageWalletImported(),
        if (_switchPageImportById) _walletImportId(),
      ],
    );
  }

  void _stackController(int _index) {
    switch (_index) {
      case 0:
        setState(() {
          _switchBuildForm = true;
          _switchChooseImportMethod = false;
          _switchImportWalletId = false;
          _switchImportPubPrivKeys = false;
          _switchWalletImported = false;
          _switchPageImportById = false;
        });
        break;
      case 1:
        setState(() {
          _switchBuildForm = false;
          _switchChooseImportMethod = true;
          _switchImportWalletId = false;
          _switchImportPubPrivKeys = false;
          _switchWalletImported = false;
          _switchPageImportById = false;
        });
        break;
      case 2:
        setState(() {
          _switchBuildForm = false;
          _switchChooseImportMethod = false;
          _switchImportWalletId = true;
          _switchImportPubPrivKeys = false;
          _switchWalletImported = false;
          _switchPageImportById = false;
        });
        break;
      case 3:
        setState(() {
          _switchBuildForm = false;
          _switchChooseImportMethod = false;
          _switchImportWalletId = false;
          _switchImportPubPrivKeys = true;
          _switchWalletImported = false;
          _switchPageImportById = false;
        });
        break;
      case 4:
        setState(() {
          _switchBuildForm = false;
          _switchChooseImportMethod = false;
          _switchImportWalletId = false;
          _switchImportPubPrivKeys = false;
          _switchWalletImported = true;
          _switchPageImportById = false;
        });
        break;
      case 5:
        setState(() {
          _switchBuildForm = false;
          _switchChooseImportMethod = false;
          _switchImportWalletId = false;
          _switchImportPubPrivKeys = false;
          _switchWalletImported = false;
          _switchPageImportById = true;
        });
        break;
    }
  }

  Future<Wallet> _saveWalletData({String walletId = ''}) async {
    await _dataStorage.addString("accountId", _createKeyAccountId.text);
    // await _dataStorage.addString("pubKey", _createKeyPublic.text);
    // await _dataStorage.addString("privKey", _createKeyPrivate.text);
    await _dataStorage.addString("walletName", _createWalletName.text);
    await _dataStorage.addString("walletId", walletId);
    print("_saveWalletData() :  $walletId");
    return Wallet(_createKeyAccountId.text, _createKeyPublic.text,
        _createKeyPrivate.text, _createWalletName.text,
        walletId: walletId);
  }

  Future<Wallet> _getWalletData() async {
    String _accountId = await _dataStorage.getStringValues("accountId") ?? '0';
    String _pubKey = await _dataStorage.getStringValues("pubKey") ?? '0';
    String _privKey = await _dataStorage.getStringValues("privKey") ?? '0';
    String _walletName =
        await _dataStorage.getStringValues("walletName") ?? '0';
    String _walletId = await _dataStorage.getStringValues("walletId") ?? '0';

    Wallet _wallet =
        Wallet(_accountId, _pubKey, _privKey, _walletName, walletId: _walletId);

    return _wallet;
  }

  void _displayWalletData(Wallet _wallet) {
    if (_wallet.accountId != '0' && _wallet.accountId != '') {
      setState(() {
        _createKeyAccountId.text = _wallet.accountId;
        // _createKeyPublic.text = _wallet.pubKey;
        // _createKeyPrivate.text = _wallet.privKey;
        _createWalletName.text = _wallet.name;
        _displayWalletId.text = _wallet.walletId;
        _importWalletIdController.text = _wallet.walletId;
      });
    } else if (_wallet.accountId == '0' &&
        _wallet.accountId != '' &&
        _wallet.walletId != '0') {
      setState(() {
        _displayWalletId.text =
            (_wallet.walletId == '0') ? '' : _wallet.walletId;
        _importWalletIdController.text =
            (_wallet.walletId == '0') ? '' : _wallet.walletId;
      });
    }
  }

  void _clearWalletDisplayData() {
    Wallet _wallet = Wallet('', '', '', '', walletId: '');
    _createKeyAccountId.text = _wallet.accountId;
    _createKeyPublic.text = _wallet.pubKey;
    _createKeyPrivate.text = _wallet.privKey;
    _createWalletName.text = _wallet.name;
    _displayWalletId.text = _wallet.walletId;
    _importWalletIdController.text = _wallet.walletId;
  }

  Future<void> _initWalletData() async {
    wallet = await _getWalletData();
    _displayWalletData(wallet);
    _controllerFlow();
    _disableSubmitIfId();
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 8.0, right: 8.0),
      child: Container(
        // height: 520,
        height: 700,
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
          key: _createWalletFormKey,
          child: Column(
            children: [
              Container(
                height: 70,
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
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft, child: _backButton()),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Center(
                        child: Text(
                          "Import Wallet",
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 18.0, right: 18.0, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                        controller: _createKeyAccountId,
                        decoration: _decoration('Hedera Account ID', '0.0.0'),
                        style: _textStyle(24),
                        keyboardType: TextInputType.number),
                    TextFormField(
                      controller: _createKeyPublic,
                      decoration: _decoration('Public Key'),
                      style: _textStyle(24),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _createKeyPrivate,
                      decoration: _decoration('Private Key'),
                      style: _textStyle(24),
                    ),
                    TextFormField(
                      controller: _createWalletName,
                      decoration: _decoration('Wallet Name'),
                      style: _textStyle(24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "This is Your Wallet ID. Save this Number! Do not Share!",
                      style: TextStyle(color: Colors.red),
                    ),
                    SelectableText(
                      _displayWalletId.text,
                      style: const TextStyle(fontSize: 18),
                      toolbarOptions: const ToolbarOptions(
                        copy: true,
                        selectAll: true,
                      ),
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: _displayWalletId.text))
                            .then(
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Copied to your clipboard!')));
                          },
                        );
                      },
                    ),
                    const Text(
                      "^ Click to copy ! ^",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _generateCreateButton(_submitButtonLogic),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wallet has been Removed')));
                  await _dataStorage.removeAll();
                  _clearWalletDisplayData();
                  _disableSubmitIfId();
                  setState(() {
                    _stackIndex = 1;
                  });
                },
                child: const Text("Remove data"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map> _submitForm() async {
    Map _data = await _seunSwapApi.createKeyStore(_createKeyAccountId.text,
        _createKeyPublic.text, _createKeyPublic.text, _createWalletName.text);
    var _temp = _data;
    print('_submitForm() :  $_temp');
    return _data;
  }

  Future<Wallet> _submitSaveWalletId() async {
    await _dataStorage.addString("walletId", _importWalletIdController.text);
    print('_submitSaveWalletId() :  _importWalletIdController.text');
    _displayWalletId.text = _importWalletIdController.text;
    return Wallet('', '', '', '', walletId: _importWalletIdController.text);
  }

  bool _isSubmitEnabled = true;

  void _disableSubmitIfId() {
    if (_displayWalletId.text != '' && _displayWalletId.text != '0' ||
        _importWalletIdController.text != '') {
      setState(() {
        _isSubmitEnabled = false;
      });
    } else {
      setState(() {
        _isSubmitEnabled = true;
      });
    }
  }

  void _submitButtonLogic() async {
    Map _walletId = await _submitForm();
    print("_submitButtonLogic() :  ${_walletId['walletId']}");
    if (_walletId['walletId'] != '' && _walletId['walletId'] != '0') {
      await _saveWalletData(walletId: _walletId['walletId']);
      Wallet _temp = await _getWalletData();

      _displayWalletId.text = _walletId['walletId'];
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wallet has been Imported!')));
      _disableSubmitIfId();
    }
  }

  void _submitWalletIdButtonLogic() async {
    _submitSaveWalletId();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet has been Imported!')));
    _disableSubmitIfId();
  }

  Widget _generateCreateButton(Function _showButton) {
    return Row(
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
            onPressed: _isSubmitEnabled
                ? () {
                    _showButton();
                  }
                : null,
            child: const Text(
              "Connect Wallet",
              style: TextStyle(fontSize: 30),
            ),
          ),
        )
      ],
    );
  }

  void _controllerFlow() {
    if (wallet.walletId == '0' || wallet.walletId == null) {
      _stackIndex = 1;
      // _stackController(1);
    } else if (wallet.walletId != '0' || wallet.walletId != '') {
      // _stackController(5);
      _stackIndex = 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    // _controllerFlow();
    _stackController(_stackIndex);

    return _messageStack();
  }
}
