import 'package:flutter/material.dart';

class OPPickVerifyModel {
  String? image;
  String? cardTitle;
  String? cardSubTitle;
  Color? cardColor;
  String? cardExpireDate;
  String? cardNumber;
  IconData? icon;
  Widget? newScreen;

  OPPickVerifyModel({this.image, this.cardTitle, this.cardSubTitle, this.cardColor, this.cardExpireDate, this.cardNumber, this.icon, this.newScreen});
}

List<OPPickVerifyModel> getCardListItems() {
  List<OPPickVerifyModel> cardList = [];
  cardList.add(OPPickVerifyModel(cardTitle: 'Video call', cardSubTitle: 'We will call you shortly', image: 'images/orapay/opvideocall.png', cardColor: Color(0xFFFF6E18)));
  cardList.add(OPPickVerifyModel(cardTitle: 'Outlets', cardSubTitle: 'You came to our outlates', image: 'images/orapay/opoutlets.png', cardColor: Color(0xFF343EDB)));
  cardList.add(OPPickVerifyModel(cardTitle: 'Agents', cardSubTitle: 'Our agents will come to you', image: 'images/orapay/opagent.png', cardColor: Color(0xFFFF6E18)));
  return cardList;
}