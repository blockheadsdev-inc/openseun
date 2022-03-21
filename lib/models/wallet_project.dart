class WalletProject {
  String id; // walletId
  String projectId;
  String accountId;
  String privKey;
  String pubKey;
  String name;
  String status;

  WalletProject(
      {this.projectId = '',
      this.accountId = '',
      this.privKey = '',
      this.pubKey = '',
      this.name = '',
      this.id = '',
      this.status = ''});
}
