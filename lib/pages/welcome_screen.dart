import 'package:flutter/material.dart';
import 'package:openseun/pages/projects_screen.dart';

class WelcomScreen extends StatelessWidget {
  const WelcomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Image.asset('assets/openseun_large_logo.jpg'),
            const SizedBox(
              height: 100,
            ),
            Container(
              width: 300.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => ProjectsScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Less carbon, more equity",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60.0,
                      width: 60.0,
                      child: const Icon(
                        Icons.chevron_right,
                        size: 40,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
