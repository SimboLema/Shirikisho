import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/model/WalletAppModel.dart';
import 'package:shirikisho/screen/WABillPayScreen.dart';
import 'package:shirikisho/screen/WAVoucherScreen.dart';
import 'package:shirikisho/screen/bimachombo/BimaChomboApplicationScreen.dart';
import 'package:shirikisho/screen/bimachombo/MkopoDetails.dart';
import 'package:shirikisho/screen/chombo/selectionMenu.dart';
import 'package:shirikisho/screen/services/VaziScreen.dart';

import '../global/environment.dart';
import '../model/social/message_model.dart';
import '../screen/driver/RegisterDriverScreen.dart';
import '../screen/empty/NoItems.dart';
import 'WAColors.dart';

List<String?> waMonthList = <String?>[
  "Jan",
  "Feb",
  "Mar",
  "April",
  "May",
  "June",
  "July",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
List<String?> waYearList = <String?>[
  "1991",
  "1992",
  "1993",
  "1994",
  "1995",
  "1996",
  "1997",
  "1998",
  "1999",
  "2020",
  "2021"
];
List<String?> waOrgList = <String?>[
  "All",
  "Water",
  "Gas",
  "Electricity",
  "Internet",
  "Education",
  "Landline"
];
List<String> paymentMethod = ["Cash", "Loan"];

List<String?> marital = ["Ndio", "Hapana"];
List<String?> gender = ["Mwanaume", "Mwanamke"];
List<String?> ownership = ["Dereva na Mmiliki", "Dereva"];
List<String?> bima = ["Ndio", "Hapana"];
List<String?> vilage = ["Ndio", "Hapana"];
List<String?> amountList = ["500", "1000", "800"];
List<String?> overViewList = ["All", "Weekly", "Yearly", "Daily", "Monthly"];
List<String?> huduma = ["LATRA", "Ada ya Maegesho", 'Ada ya Shirikisho'];

List<WAWalkThroughModel> waWalkThroughList() {
  List<WAWalkThroughModel> list = [];
  list.add(WAWalkThroughModel(
      title: "Easily Accessible",
      description:
          "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.",
      image: 'images/walletApp/wa_walkthorugh.png'));
  list.add(WAWalkThroughModel(
      title: "Mange Anytime",
      description:
          "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.",
      image: 'images/walletApp/wa_walkthorugh.png'));
  list.add(WAWalkThroughModel(
      title: "Safe Transaction",
      description:
          "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.",
      image: 'images/walletApp/wa_walkthorugh.png'));

  return list;
}

List<WACardModel> waCardList() {
  List<WACardModel> cardList = [];
  cardList.add(WACardModel(
      balance: '\$12,00,000',
      cardNumber: '123 985 7654327',
      date: '03/23',
      color: Color(0xFF6C56F9)));
  cardList.add(WACardModel(
      balance: '\$12,23,000',
      cardNumber: '985 123 7654327',
      date: '25/23',
      color: Color(0xFFFF7426)));
  cardList.add(WACardModel(
      balance: '\$23,00,000',
      cardNumber: '765 123 9854327',
      date: '03/25',
      color: Color(0xFF26C884)));
  return cardList;
}

List<VillageModel> shiVillageList() {
  List<VillageModel> villageList = [];
  villageList.add(VillageModel(id: '1', name: 'One'));
  villageList.add(VillageModel(id: '2', name: 'Two'));
  villageList.add(VillageModel(id: '3', name: 'Three'));
  villageList.add(VillageModel(id: '4', name: 'Four'));
  return villageList;
}

List<WAOperationsModel> waOperationList() {
  List<WAOperationsModel> operationModel = [];
  operationModel.add(WAOperationsModel(
    color: Color(0xFF6C56F9),
    title: 'Sajili',
    image: 'images/walletApp/wa_transfer.png',
    widget: RegisterDriverScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: Color(0xFFFF7426),
    title: 'Hakiki',
    image: 'images/walletApp/wa_voucher.png',
    widget: WAVoucherScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: Color(0xFF6C56F9),
    title: 'Wanachama',
    image: 'images/walletApp/wa_ticket.png',
    widget: VaziScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: Color(0xFF26C884),
    title: 'Vazi',
    image: 'images/walletApp/wa_bill_pay.png',
    widget: WABillPayScreen(),
  ));
  return operationModel;
}

List<WAOperationsModel> serviceList() {
  List<WAOperationsModel> operationModel = [];
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Maegesho',
    image: 'assets/images/halmashauri.png',
    widget: RegisterDriverScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'LATRA',
    image: 'assets/images/latra.png',
    widget: WABillPayScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'TRA',
    image: 'assets/images/tra.png',
    widget: WAVoucherScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Vazi',
    image: 'assets/images/cloth.webp',
    widget: VaziScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'N-Card',
    image: 'assets/images/ncard.png',
    widget: WABillPayScreen(),
  ));
  // operationModel.add(WAOperationsModel(color: WAPrimaryColor, title: 'Chombo', image: 'assets/images/bike.png', widget: WABillPayScreen(),));
  // operationModel.add(WAOperationsModel(color: WAPrimaryColor, title: 'Chombo', image: 'assets/images/bike.png', widget: MKopoDialog(),));
  // operationModel.add(WAOperationsModel(color: WAPrimaryColor, title: 'Chombo', image: 'assets/images/bike.png', widget: RequestMkopoForm(),));
  // operationModel.add(WAOperationsModel(color: WAPrimaryColor, title: 'Chombo', image: 'assets/images/bike.png', widget: MkopoForm(),));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Chombo',
    image: 'assets/images/bike.png',
    widget: MkopoChomboServicesScreen(),
  ));

  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Afya',
    image: 'assets/images/health.png',
    widget: VaziScreen(),
  ));

  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Kidebe',
    image: 'assets/images/pump.png',
    widget: RegisterDriverScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Kopa Simu',
    image: 'assets/images/phone.png',
    widget: WAVoucherScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Spare Parts',
    image: 'assets/images/spare.png',
    widget: VaziScreen(),
  ));
  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'Bima ya Ajali',
    image: 'assets/bima/sanlam.png',
    widget: NoChatsScreen2(),
  ));

  operationModel.add(WAOperationsModel(
    color: WAPrimaryColor,
    title: 'SACCOS',
    image: 'assets/images/saccos.png',
    widget: WABillPayScreen(),
  ));

  operationModel.add(
    WAOperationsModel(
      color: WAPrimaryColor,
      title: 'Bima ya Chombo',
      image: 'assets/images/bike.png',
      // widget: MkopoChomboServicesScreen(),
      // widget: BimaChomboApplicationScreen(),
      widget: MkopoBimaDetails()
    ),
  );

  // operationModel.add(WAOperationsModel(color: WAPrimaryColor, title: 'Ripoti Tukio', image: 'assets/images/saccos.png', widget: WABillPayScreen(),));
  return operationModel;
}

List<mitandaoModel> mitandaoList() {
  List<mitandaoModel> operationModel = [];

  operationModel.add(mitandaoModel(
    color: WAPrimaryColor,
    title: 'Tigo Pesa',
    image: 'assets/logo/tigo.png',
    widget: RegisterDriverScreen(),
  ));
  operationModel.add(mitandaoModel(
    color: WAPrimaryColor,
    title: 'Airtel',
    image: 'assets/logo/airtel.png',
    widget: WAVoucherScreen(),
  ));
  operationModel.add(mitandaoModel(
    color: WAPrimaryColor,
    title: 'Halopesa',
    image: 'assets/logo/halopesa.png',
    widget: VaziScreen(),
  ));
  operationModel.add(mitandaoModel(
    color: WAPrimaryColor,
    title: 'M-Pesa',
    image: 'assets/logo/voda.png',
    widget: WABillPayScreen(),
  ));

  return operationModel;
}

List<WATransactionModel> waTransactionList() {
  List<WATransactionModel> transactionList = [];
  transactionList.add(WATransactionModel(
    color: Color(0xFF26C884),
    title: 'Malipo Ya',
    image: 'assets/images/cloth.webp',
    balance: 'TZS 0',
    name: 'Vazi',
    time: 'Today 5:30 PM',
  ));
  transactionList.add(WATransactionModel(
    color: Color(0xFF26C884),
    title: 'Malipo ya ',
    image: 'assets/images/latra.png',
    balance: 'TZS 0',
    name: 'Latra',
    time: 'Today 6:30 PM',
  ));
  return transactionList;
}

List<WARecentPayeesModel> waRecentPayeesList() {
  List<WARecentPayeesModel> list = [];
  list.add(WARecentPayeesModel(
      image:
          'https://www.vrsiddhartha.ac.in/me/wp-content/uploads/learn-press-profile/4/172522ec1028ab781d9dfd17eaca4427.jpg',
      name: 'John',
      number: '123456789'));
  list.add(WARecentPayeesModel(
      image:
          'https://royalrajtravels.com/image/1613583503main-qimg-6291c3a117fc230c82785148baef7eed.jpg',
      name: 'Rose',
      number: '78571237'));
  list.add(WARecentPayeesModel(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5yt4pfdz3-lacajgUY5xuRuciElEaMZa9luc29Vgx2oVLDQceaFmxgcUXRzU-IfTZcWA&usqp=CAU',
      name: 'Willam',
      number: '456123522'));
  list.add(WARecentPayeesModel(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5yt4pfdz3-lacajgUY5xuRuciElEaMZa9luc29Vgx2oVLDQceaFmxgcUXRzU-IfTZcWA&usqp=CAU',
      name: 'Willam',
      number: '5568553522'));
  list.add(WARecentPayeesModel(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5yt4pfdz3-lacajgUY5xuRuciElEaMZa9luc29Vgx2oVLDQceaFmxgcUXRzU-IfTZcWA&usqp=CAU',
      name: 'Willam',
      number: '852123522'));
  list.add(WARecentPayeesModel(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIuNPlLLXKdjlBivtZzQxsq-hW9E6YbooFXqDqST7AfuSHGcN45DIDTi5qeLOQHNrNR9g&usqp=CAU',
      name: 'Rose',
      number: '4561222222'));
  list.add(WARecentPayeesModel(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSw9jzCKDNeX4QbAQOAABXMML3djP3ZVEv1-rpbKgfyNCshsC-zhB3Ta2JXdMxvvSOFszg&usqp=CAU',
      name: 'Bella',
      number: '98561233'));
  return list;
}

List<WABillPayModel> waBillPayList() {
  List<WABillPayModel> list = [];
  if (IsLeader) {
    list.add(WABillPayModel(
        title: 'Sajili',
        color: WAPrimaryColor,
        image: 'assets/images/add_user.png'));
  }
  list.add(WABillPayModel(
      title: 'Hakiki',
      color: WAPrimaryColor,
      image: 'assets/images/verify.png'));
  list.add(WABillPayModel(
      title: 'Maafisa',
      color: WAPrimaryColor,
      image: 'assets/images/members.png'));
  return list;
}

List<WABillPayModel> govPayList() {
  List<WABillPayModel> list = [];
  list.add(WABillPayModel(
      title: 'Maegesho',
      color: WAPrimaryColor,
      image: 'assets/images/halmashauri.png'));
  list.add(WABillPayModel(
      title: 'LATRA', color: WAPrimaryColor, image: 'assets/images/latra.png'));
  list.add(WABillPayModel(
      title: 'Leseni', color: WAPrimaryColor, image: 'assets/images/tra.png'));
  return list;
}

List<WAOrganizationModel> waOrganizationList() {
  List<WAOrganizationModel> list = [];
  list.add(WAOrganizationModel(
      color: Colors.blue,
      image: 'images/walletApp/wa_water.png',
      title: 'Eco Water',
      subTitle: 'Water Supplier'));
  list.add(WAOrganizationModel(
      color: Colors.yellow,
      image: 'images/walletApp/wa_electricity.png',
      title: 'bolt Powergrid',
      subTitle: 'Electricity Supplier'));
  list.add(WAOrganizationModel(
      color: Colors.pink,
      image: 'images/walletApp/wa_internet.png',
      title: 'Nina Network',
      subTitle: 'Internet Supplier'));
  list.add(WAOrganizationModel(
      color: Colors.yellow,
      image: 'images/walletApp/wa_electricity.png',
      title: 'Green Energy ',
      subTitle: 'Electricity Supplier'));
  list.add(WAOrganizationModel(
      color: Colors.pink,
      image: 'images/walletApp/wa_internet.png',
      title: 'Express Internet',
      subTitle: 'Internet Supplier'));
  return list;
}

List<WABillPayModel> waSelectBillList() {
  List<WABillPayModel> list = [];
  list.add(WABillPayModel(
      title: 'CityBank', image: 'images/walletApp/wa_city_bank_image.png'));
  list.add(WABillPayModel(
      title: 'Bank of America',
      image: 'images/walletApp/wa_bank_of_america.png'));
  list.add(WABillPayModel(
      title: 'Yes Bank', image: 'images/walletApp/wa_yes_bank.png'));
  return list;
}

List<WACardModel> waSendViaCardList() {
  List<WACardModel> list = [];
  list.add(WACardModel(
      balance: '\$12,00,000',
      cardNumber: '123 985 7654327',
      date: '03/23',
      color: Color(0xFF6C56F9),
      image: 'images/walletApp/wa_card.png'));
  list.add(WACardModel(
      balance: '\$12,23,000',
      cardNumber: '985 123 7654327',
      date: '25/23',
      color: Color(0xFFFF7426),
      image: 'images/walletApp/wa_card.png'));
  list.add(WACardModel(
      balance: '\$23,00,000',
      cardNumber: '765 123 9854327',
      date: '03/25',
      color: Color(0xFF26C884),
      image: 'images/walletApp/wa_card.png'));
  return list;
}

List<WAWalletUserModel> waWalletUserList() {
  List<WAWalletUserModel> list = [];
  list.add(WAWalletUserModel(
      image:
          "https://www.vrsiddhartha.ac.in/me/wp-content/uploads/learn-press-profile/4/172522ec1028ab781d9dfd17eaca4427.jpg"));
  list.add(WAWalletUserModel(
      image:
          "https://royalrajtravels.com/image/1613583503main-qimg-6291c3a117fc230c82785148baef7eed.jpg"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5yt4pfdz3-lacajgUY5xuRuciElEaMZa9luc29Vgx2oVLDQceaFmxgcUXRzU-IfTZcWA&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXs_iIewEiaZ3tXb6n6VgaUIONS0B0HjwsqcvA3-EnnaNm0BwX216u2dZl2QTHnP7VOIU&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7wtiaB5F3B2oaF5699EJCNEtPnjD57ERWKTMjN0h-gpRxrFQ1u68HzFFT3eYJFFNLr4&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7wtiaB5F3B2oaF5699EJCNEtPnjD57ERWKTMjN0h-gpRxrFQ1u68HzFFT3eYJFFNLr4&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7wtiaB5F3B2oaF5699EJCNEtPnjD57ERWKTMjN0h-gpRxrFQ1u68HzFFT3eYJFFNLr4&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7wtiaB5F3B2oaF5699EJCNEtPnjD57ERWKTMjN0h-gpRxrFQ1u68HzFFT3eYJFFNLr4&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7wtiaB5F3B2oaF5699EJCNEtPnjD57ERWKTMjN0h-gpRxrFQ1u68HzFFT3eYJFFNLr4&usqp=CAU"));
  list.add(WAWalletUserModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7wtiaB5F3B2oaF5699EJCNEtPnjD57ERWKTMjN0h-gpRxrFQ1u68HzFFT3eYJFFNLr4&usqp=CAU"));
  return list;
}

List<WATransactionModel> waCategoriesList() {
  List<WATransactionModel> list = [];
  list.add(WATransactionModel(
      color: Color(0xFF26C884),
      title: 'Clothes',
      image: 'images/walletApp/wa_clothes.png',
      balance: '-\$10,000',
      time: 'Today 12:30 PM'));
  list.add(WATransactionModel(
      color: Color(0xFFFF7426),
      title: 'Grocery',
      image: 'images/walletApp/wa_food.png',
      balance: '-\$8,000',
      time: 'Today 1:02 PM'));
  return list;
}

List<WAVoucherModel> waVouchersList() {
  List<WAVoucherModel> list = [];
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_zara.png',
      title: 'ZARA Fashion',
      discountText: '10% Off',
      expireTime: 'Expires on 15 June',
      pointsText: 'For 1500 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_macdonals.jpeg',
      title: 'Mcdonald\'s',
      discountText: '5% Off',
      expireTime: 'Expires on 20 June',
      pointsText: 'For 600 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_macdonals.jpeg',
      title: 'Mcdonald\'s',
      discountText: '5% Off',
      expireTime: 'Expires on 20 June',
      pointsText: 'For 600 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_zara.png',
      title: 'ZARA Fashion',
      discountText: '10% Off',
      expireTime: 'Expires on 15 June',
      pointsText: 'For 1500 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_zara.png',
      title: 'ZARA Fashion',
      discountText: '10% Off',
      expireTime: 'Expires on 15 June',
      pointsText: 'For 1500 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_macdonals.jpeg',
      title: 'Mcdonald\'s',
      discountText: '5% Off',
      expireTime: 'Expires on 20 June',
      pointsText: 'For 600 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_macdonals.jpeg',
      title: 'Mcdonald\'s',
      discountText: '5% Off',
      expireTime: 'Expires on 20 June',
      pointsText: 'For 600 points'));
  list.add(WAVoucherModel(
      image: 'images/walletApp/wa_zara.png',
      title: 'ZARA Fashion',
      discountText: '10% Off',
      expireTime: 'Expires on 15 June',
      pointsText: 'For 1500 points'));
  return list;
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: 'images/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: 'images/flag/ic_hi.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: 'images/flag/ic_fr.png'),
  ];
}

List<MessageListModel> getMessageList() {
  List<MessageListModel> messageList = [];
  messageList.add(
    MessageListModel(
        id: 1,
        img: t14_profile1,
        name: 'Fletcher Jenkins',
        message: 'I like these sweet morning of',
        lastSeen: "12:10",
        isActive: true),
  );
  messageList.add(
    MessageListModel(
        id: 1,
        img: t14_profile2,
        name: 'David Steward',
        message: 'I am alone feel the good',
        lastSeen: "Yesterday",
        isActive: false),
  );

  return messageList;
}

List<BHMessageModel> getChatMsgData() {
  List<BHMessageModel> list = [];

  // BHMessageModel c1 = BHMessageModel();
  // c1.senderId = BHSender_id;
  // c1.receiverId = BHReceiver_id;
  // c1.msg = 'Helloo';
  // c1.time = '1:43 AM';
  // list.add(c1);
  //
  // BHMessageModel c2 = BHMessageModel();
  // c2.senderId = BHSender_id;
  // c2.receiverId = BHReceiver_id;
  // c2.msg = 'How are you? What are you doing?';
  // c2.time = '1:45 AM';
  // list.add(c2);
  //
  // BHMessageModel c3 = BHMessageModel();
  // c3.senderId = BHReceiver_id;
  // c3.receiverId = BHSender_id;
  // c3.msg = 'Helloo...';
  // c3.time = '1:45 AM';
  // list.add(c3);
  //
  // BHMessageModel c4 = BHMessageModel();
  // c4.senderId = BHSender_id;
  // c4.receiverId = BHReceiver_id;
  // c4.msg = 'I am good. Can you do something for me? I need your help.';
  // c4.time = '1:45 AM';
  // list.add(c4);
  //
  // BHMessageModel c5 = BHMessageModel();
  // c5.senderId = BHSender_id;
  // c5.receiverId = BHReceiver_id;
  // c5.msg = 'I am good. Can you do something for me? I need your help.';
  // c5.time = '1:45 AM';
  // list.add(c5);
  //
  // BHMessageModel c6 = BHMessageModel();
  // c6.senderId = BHReceiver_id;
  // c6.receiverId = BHSender_id;
  // c6.msg = 'I am good. Can you do something for me? I need your help.';
  // c6.time = '1:45 AM';
  // list.add(c6);
  //
  // BHMessageModel c7 = BHMessageModel();
  // c7.senderId = BHSender_id;
  // c7.receiverId = BHReceiver_id;
  // c7.msg = 'I am good. Can you do something for me? I need your help.';
  // c7.time = '1:45 AM';
  // list.add(c7);
  //
  // BHMessageModel c8 = BHMessageModel();
  // c8.senderId = BHReceiver_id;
  // c8.receiverId = BHSender_id;
  // c8.msg = 'I am good. Can you do something for me? I need your help.';
  // c8.time = '1:45 AM';
  // list.add(c8);
  //
  // BHMessageModel c9 = BHMessageModel();
  // c9.senderId = BHSender_id;
  // c9.receiverId = BHReceiver_id;
  // c9.msg = 'I am good. Can you do something for me? I need your help.';
  // c9.time = '1:45 AM';
  // list.add(c9);
  //
  // BHMessageModel c10 = BHMessageModel();
  // c10.senderId = BHReceiver_id;
  // c10.receiverId = BHSender_id;
  // c10.msg = 'I am good. Can you do something for me? I need your help.';
  // c10.time = '1:45 AM';
  // list.add(c10);
  //
  // BHMessageModel c11 = BHMessageModel();
  // c11.senderId = BHReceiver_id;
  // c11.receiverId = BHSender_id;
  // c11.msg = 'I am good. Can you do something for me? I need your help.';
  // c11.time = '1:45 AM';
  // list.add(c11);
  //
  // BHMessageModel c12 = BHMessageModel();
  // c12.senderId = BHSender_id;
  // c12.receiverId = BHReceiver_id;
  // c12.msg = 'I am good. Can you do something for me? I need your help.';
  // c12.time = '1:45 AM';
  // list.add(c12);
  //
  // BHMessageModel c13 = BHMessageModel();
  // c13.senderId = BHSender_id;
  // c13.receiverId = BHReceiver_id;
  // c13.msg = 'I am good. Can you do something for me? I need your help.';
  // c13.time = '1:45 AM';
  // list.add(c13);
  //
  // BHMessageModel c14 = BHMessageModel();
  // c14.senderId = BHReceiver_id;
  // c14.receiverId = BHSender_id;
  // c14.msg = 'I am good. Can you do something for me? I need your help.';
  // c14.time = '1:45 AM';
  // list.add(c14);
  //
  // BHMessageModel c15 = BHMessageModel();
  // c15.senderId = BHSender_id;
  // c15.receiverId = BHReceiver_id;
  // c15.msg = 'I am good. Can you do something for me? I need your help.';
  // c15.time = '1:45 AM';
  // list.add(c15);
  //
  // BHMessageModel c16 = BHMessageModel();
  // c16.senderId = BHReceiver_id;
  // c16.receiverId = BHSender_id;
  // c16.msg = 'I am good. Can you do something for me? I need your help.';
  // c16.time = '1:45 AM';
  // list.add(c16);
  //
  // BHMessageModel c17 = BHMessageModel();
  // c17.senderId = BHSender_id;
  // c17.receiverId = BHReceiver_id;
  // c17.msg = 'I am good. Can you do something for me? I need your help.';
  // c17.time = '1:45 AM';
  // list.add(c17);
  //
  // BHMessageModel c18 = BHMessageModel();
  // c18.senderId = BHReceiver_id;
  // c18.receiverId = BHSender_id;
  // c18.msg = 'I am good. Can you do something for me? I need your help.';
  // c18.time = '1:45 AM';
  // list.add(c18);

  return list;
}

class SVPostModel {
  String? name;
  String? profileImage;
  String? postImage;
  String? time;
  String? description;
  int? commentCount;
  bool? like;

  SVPostModel(
      {this.name,
      this.profileImage,
      this.postImage,
      this.time,
      this.description,
      this.commentCount,
      this.like});
}

List<SVPostModel> getPosts() {
  List<SVPostModel> list = [];

  list.add(
    SVPostModel(
      name: 'Manny',
      profileImage: '$OldBaseUrl/images/socialv/faces/face_3.png',
      time: '4m',
      postImage: '$OldBaseUrl/images/socialv/postImage.png',
      description:
          'The great thing about reaching the top of the mountain is realising that there’s space for more than one person.',
      commentCount: 0,
      like: false,
    ),
  );
  list.add(
    SVPostModel(
      name: 'Isabelle',
      profileImage: '$OldBaseUrl/images/socialv/faces/face_4.png',
      time: '4m',
      postImage: '$OldBaseUrl/images/socialv/postImage.png',
      commentCount: 0,
      like: false,
    ),
  );
  list.add(
    SVPostModel(
      name: 'Jenny Wilson',
      profileImage: '$OldBaseUrl/images/socialv/faces/face_5.png',
      time: '4m',
      postImage: '$OldBaseUrl/images/socialv/postImage.png',
      description: 'Making memories that last a lifetime ',
      commentCount: 0,
      like: false,
    ),
  );

  return list;
}
