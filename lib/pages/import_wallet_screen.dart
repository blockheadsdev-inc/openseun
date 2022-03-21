import 'package:flutter/material.dart';
import 'package:openseun/modules/menu_drawer.dart';

class ImportWalletFromId extends StatefulWidget {
  const ImportWalletFromId({Key? key}) : super(key: key);

  @override
  State<ImportWalletFromId> createState() => _ImportWalletFromIdState();
}

class _ImportWalletFromIdState extends State<ImportWalletFromId> {
  late TextEditingController _importWalletIdController;
  final Key _importWalletFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _importWalletIdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _importWalletIdController.dispose();
    super.dispose();
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
            onPressed: () {
              _showButton();
            },
            child: const Text(
              "Connect Wallet",
              style: TextStyle(fontSize: 30),
            ),
          ),
        )
      ],
    );
  }

  Widget _walletImportId() {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Clear Water Projects'),
      ),
      body: Padding(
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
            key: _importWalletFormKey,
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
                        decoration: const InputDecoration(
                          labelText: 'WalletID',
                        ),
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _generateCreateButton(() {}),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Wallet has been Removed')));
                    // await _dataStorage.removeAll();
                    // _clearWalletDisplayData();
                    // _disableSubmitIfId();
                    // setState(() {
                    //   _stackIndex = 1;
                    // });
                  },
                  child: const Text("Remove data"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _walletImportId();
  }
}
