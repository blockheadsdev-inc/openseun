import 'package:flutter/material.dart';

class TokenHbar {
  String tokenFullName = "Hedera";
  String tokenAbbrName = "HBAR";
  String tokenValueType = "double";
  String assetLocation = "assets/hedera-hashgraph.png";
  // String tokenIcon = "assets/hedera-hashgraph.png";
  Widget tokenIcon = Image.asset(
    'assets/hedera-hashgraph.png',
    width: 20,
  );
}
