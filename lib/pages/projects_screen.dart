import 'package:flutter/material.dart';

import '../modules/menu_drawer.dart';
import '../modules/project_tile.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Clear Water Projects'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black12,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              ProjectTileCard(
                title: "Green Africa- Efficient Cook Stove Replacement",
                description:
                    "A project in Africa that benefits 200,000 people in Malawi. The team replaced traditional three-stone cooking fires with fuel efficient stoves. This reduces greenhouse gas emissions when boiling water.",
                image: Image.asset('assets/malawi.jpg'),
              ),
              ProjectTileCard(
                title: "WaterClear Cambodia",
                description:
                    "This project encourages communities to utilize filters to purify their water sources rather than the usual fuel intensive wood or charcoal burning stoves.",
                image: Image.asset('assets/cambodia.jpg'),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Total: 500",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black38),
                            onPressed: () {},
                            child: Text("Mint to Wallet")),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
