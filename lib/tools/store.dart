class Store {
  String itemName;
  double itemPrice;
  String itemImage;
  double itemRating;
  Store.items({this.itemName, this.itemPrice, this.itemImage, this.itemRating});
}

List<Store> storeItems = [
  Store.items(
      itemName: "Pink Can",
      itemPrice: 50.0,
      itemImage: "https://bit.ly/2UnbqBj",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 25.0,
      itemImage: "https://bit.ly/2ygeRBi",
      itemRating: 0.0),
  Store.items(
      itemName: "Back Off Shoulder",
      itemPrice: 60.0,
      itemImage: "https://bit.ly/3dBfjdz",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 25.0,
      itemImage: "https://bit.ly/2UDalUY",
      itemRating: 0.0),
  Store.items(
      itemName: "Blue Boomshot",
      itemPrice: 10.0,
      itemImage: "https://bit.ly/2Uqyj7a",
      itemRating: 0.0),
];
