class Token {
  final String walletTokenId;
  final String walletId;
  final String tokenId;
  final String tokenName;
  final int price;
  final int balance;

  Token(this.walletTokenId, this.walletId, this.tokenId, this.tokenName,
      this.price, this.balance);
}
