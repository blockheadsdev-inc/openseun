class Wallet {
  String accountId;
  String privKey;
  String pubKey;
  String name;
  String walletId;

  Wallet(this.accountId, this.privKey, this.pubKey, this.name,
      {this.walletId = ''});
}
