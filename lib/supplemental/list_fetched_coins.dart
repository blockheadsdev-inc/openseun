import 'package:flutter/material.dart';
import 'package:seunswap/api/seunswap_api.dart';

import '../api/data_local_storage.dart';
import '../models/wallet_class.dart';

class ListFetchedCoins extends StatefulWidget {
  final TabController tabController;
  const ListFetchedCoins({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<ListFetchedCoins> createState() => _ListFetchedCoinsState();
}

class _ListFetchedCoinsState extends State<ListFetchedCoins>
    with TickerProviderStateMixin {
  final LocalData _dataStorage = LocalData();
  final SeunSwapApi _seunSwapApi = SeunSwapApi();
  late TabController _tabControllerList;

  // late String _walletIdFromLocal;
  Wallet wallet = Wallet('', '', '', '');

  @override
  void initState() {
    _tabControllerList = TabController(length: 2, vsync: this, initialIndex: 0);
    // _walletIdFromLocal = (await _dataStorage.getStringValues("walletId"))!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabControllerList.dispose();
  }

  double _tinyBarToHbar(int _tbar) {
    double _r = _tbar / 100000000;
    return _r;
  }

  void _saveTokenOnTap(_tokenId, _tokenWalletId, _tokenWalletWalletId) async {
    await _dataStorage.saveSelectedToken(
        _tokenId, _tokenWalletId, _tokenWalletWalletId);
  }

  Widget _buildOwnedList() {
    return FutureBuilder(
        future: _seunSwapApi.fetchOwnedTokens(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Text(
                "loading...",
                style: TextStyle(fontSize: 30.0),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  double _tinyBars = _tinyBarToHbar(snapshot.data[index].price);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Token ID:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${snapshot.data[index].tokenId}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "Balance: ${snapshot.data[index].balance.toString()}",
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '(${_tinyBars.toString()} ℏ)',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          onTap: () {
                            _saveTokenOnTap(
                                snapshot.data[index].tokenId,
                                snapshot.data[index].walletTokenId,
                                snapshot.data[index].walletId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Selected Token ID ${snapshot.data[index].tokenId}')));
                            setState(() {
                              widget.tabController.index = 0;
                            });
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                    ],
                  );
                });
          }
        });
  }

  _buildAllListed() {
    return FutureBuilder(
        future: _seunSwapApi.fetchListedTokens(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: const Center(
                child: Text(
                  "loading...",
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  double _tinyBars = _tinyBarToHbar(snapshot.data[index].price);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data[index].tokenName,
                                style: TextStyle(fontSize: 20),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "ID:",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${snapshot.data[index].tokenId}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          subtitle: const Text(''
                              // "Amount: ${snapshot.data[index].balance.toString()}",
                              ),
                          trailing: Column(
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '(${_tinyBars.toString()} ℏ)',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          onTap: () {
                            _saveTokenOnTap(
                                snapshot.data[index].tokenId,
                                snapshot.data[index].walletTokenId,
                                snapshot.data[index].walletId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Selected Token ID ${snapshot.data[index].tokenId}')));
                            setState(() {
                              widget.tabController.index = 0;
                            });
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                    ],
                  );
                });
          }
        });
  }

  Widget _buildOwnedListContainer() {
    return Column(
      children: [
        Expanded(
          child: _buildOwnedList(),
        ),
      ],
    );
  }

  Widget _buildListContainer() {
    return Column(
      children: [
        Expanded(
          child: _buildAllListed(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _ownedList = _buildOwnedListContainer();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          controller: _tabControllerList,
          labelColor: Colors.blue,
          tabs: const [
            Tab(
              // icon: Icon(Icons.home),
              text: "All Tokens",
            ),
            Tab(
              // icon: Icon(Icons.settings),
              text: "Owned Tokens",
            )
          ],
        ),
        Container(
          // color: Colors.pink,
          height: MediaQuery.of(context).size.height - 185,
          child: TabBarView(
            controller: _tabControllerList,
            children: [
              // Container(child: Center(child: Text('testing'))),
              Container(child: _buildListContainer()),
              Container(child: _ownedList),
            ],
          ),
        ),
      ],
    );
  }
}
