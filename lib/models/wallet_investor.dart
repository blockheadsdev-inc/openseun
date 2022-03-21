class WalletInvestor {
  String id; // walletId
  String investorId;
  String accountId;
  String privKey;
  String pubKey;
  String name;
  String status;

  WalletInvestor(
      {this.investorId = '',
      this.accountId = '',
      this.privKey = '',
      this.pubKey = '',
      this.name = '',
      this.id = '',
      this.status = ''});
}
