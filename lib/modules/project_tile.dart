import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectTileCard extends StatefulWidget {
  final String description;
  final String title;
  const ProjectTileCard({
    Key? key,
    required this.description,
    required this.title,
  }) : super(key: key);

  @override
  State<ProjectTileCard> createState() => _ProjectTileCardState();
}

class _ProjectTileCardState extends State<ProjectTileCard> {
  late TextEditingController _buyAmount;
  final Image _placeHolderImage = Image.asset('assets/placeholder.jpg');
  final Text _textPlaceHolder = const Text(
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
    // overflow: TextOverflow.clip,
    style: TextStyle(fontSize: 12, color: Colors.black54),
  );

  @override
  void initState() {
    _buyAmount = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _buyAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        color: Colors.white,
        height: 200.0,
        width: MediaQuery.of(context).size.width - 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // color: Colors.red,
              height: 160.0,
              child: _placeHolderImage,
            ),
            Container(
              height: 160,
              // color: Colors.purple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                        // color: Colors.orange,
                        width: 200,
                        height: 95,
                        child: _textPlaceHolder),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  SizedBox(
                    width: 190,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("Qty: 250"),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  "Buy: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              // color: Colors.black,
                              height: 40,
                              width: 50.0,
                              child: TextField(
                                controller: _buyAmount,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    // labelText: "Buy",
                                    ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
