import 'package:flutter/material.dart';
import 'package:seunswap/supplemental/create_wallet_form.dart';
import 'package:seunswap/supplemental/list_coin_form.dart';
import 'package:seunswap/supplemental/list_fetched_coins.dart';
import 'package:seunswap/supplemental/swap_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // asyncFunc() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  // }
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.swap_vert_circle_rounded,
                size: 40,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.format_list_bulleted_rounded,
                size: 40,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.generating_tokens_rounded,
                size: 40,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.account_balance_wallet,
                size: 40,
              ),
            ),
          ],
        ),
        title: const Text(
          'SEUNswap',
          // style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SwapTokenForm(
                  tabController: _tabController,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: ListFetchedCoins(tabController: _tabController),
          ),
          // ListFetchedCoins(tabController: _tabController),
          SingleChildScrollView(
            child: ListCoinForm(tabController: _tabController),
          ),
          // ListCoinForm(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CreateWalletForm(),
              ],
            ),
          ),
        ],
      ),
      // child: _createWalletForm(),
    );
  }
}
