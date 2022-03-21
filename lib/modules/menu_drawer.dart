import 'package:flutter/material.dart';

import '../pages/import_wallet_screen.dart';
import '../pages/projects_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        // elevation: 6,
        // backgroundColor: Colors.lightBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 86,
              color: Colors.blue,
              child: const DrawerHeader(
                child: Center(
                    child: Text(
                  "OpenSEUN",
                  style: TextStyle(color: Colors.white),
                )),
                // decoration: ,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => ProjectsScreen()));
              },
              child: const ListTile(
                title: Text('Projects'),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => ImportWalletFromId()));
              },
              child: const ListTile(
                title: Text('Wallet'),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (_) => ImportWalletFromId()));
              },
              child: const ListTile(
                title: Text('Investor'),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
