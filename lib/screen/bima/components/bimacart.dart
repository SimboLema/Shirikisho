import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/global/environment.dart';
import 'package:shirikisho/screen/bima/components/helpers.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/utils/WAWidgets.dart';

class PaymentCard extends StatefulWidget {
  /// The `PaymentCard` constructor.
  ///
  /// Creates a payment card widget.
  ///
  /// [cardIssuerIcon] is an optional widget representing the card issuer icon.
  /// [backgroundColor] is the background color of the card.
  /// [backgroundGradient] is the background gradient color of the card.
  /// [backgroundImage] is the background image of the card.
  /// [currency] is the currency text widget.
  /// [cardNumber] is the card number.
  /// [validity] is the validity date of the card.
  /// [holder] is the name of the card holder.
  /// [cardNetwork] is the type of card network.
  /// [cardTypeTextStyle] is the text style for displaying the card type.
  /// [cardNumberStyles] is the style for displaying the card number.
  /// [margin] is the margin around the card.
  /// [cardNumberDivision] is the division number for spacing the card number.
  /// [isStrict] parameter specifies whether to validate the card number strictly.
  const PaymentCard({
    super.key,
    // this.cardIssuerIcon = const CardIcon(),
    required this.backgroundColor,
    this.backgroundGradient,
    required this.backgroundImage,
    required this.currency,
    required this.cardNumber,
    required this.validity,
    required this.start,
    required this.colors,
    required this.holder,
    required this.title,
    required this.status,
    required this.statusAppear,
    required this.imagePkg,
    required this.userProfile,
    required this.companyLogo,
    required this.companyLogo2,
    required this.secondComp,

    // this.cardNetwork = CardNetwork.other,
    this.cardTypeTextStyle,
    // this.cardNumberStyles,
    this.margin,
    this.cardNumberDivision,
    this.isStrict = true,
  });

  // Parameter documentation

  /// The icon representing the card issuer.
  // final CardIcon? cardIssuerIcon;

  /// The background color of the payment card.
  final Color? backgroundColor;

  final Color? colors;

  /// The background gradient color of the payment card.
  final LinearGradient? backgroundGradient;

  /// The background image of the payment card.
  final String? backgroundImage;

  /// The currency text displayed on the payment card.
  // final Text? currency;
  final String? currency;

  final bool status;
  final bool statusAppear;

  /// The card number.
  final String cardNumber;

  final String? userProfile;

  final String? companyLogo;

  final String? companyLogo2;
  final bool secondComp;

  /// Whether to validate the card number strictly.
  final bool isStrict;

  /// The number of digits to group together in the card number.
  final int? cardNumberDivision;

  /// The validity date of the card.
  final String validity;
  final String start;

  final String imagePkg;

  /// The name of the card holder.
  final String holder;

  final String? title;

  /// The network of the card.
  // final CardNetwork? cardNetwork;

  /// The text style for the card type.
  final TextStyle? cardTypeTextStyle;

  final EdgeInsetsGeometry? margin;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  late AuthService authService;
  var profileImage = "";
  var userName = "";
  var userImage = "";
  var phone = "";
  var avatar = "/office/media/avatars/300-1.jpg";
  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    getUserData();
    init();
  }

  Future<void> init() async {
    //
  }
  Future<void> getUserData() async {
    setState(
      () {
        userName = authService.user.firstName!;
        userImage = authService.user.imageId!;
        phone = authService.user.phoneNumber!;

        log(userImage);
      },
    );
    // print("user image $userImage");
  }

  // Possible bugs
  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.25;
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    // print("card height $cardHeight   width $cardWidth");
    // print("user profile ${widget.userProfile}");
    Color? kColor;
    if (widget.backgroundColor == Colors.deepOrange ||
        widget.backgroundColor == Colors.deepOrangeAccent) {
      kColor = Colors.black12;
    } else {
      kColor = null;
    }
    return LayoutBuilder(builder: (context, c) {
      //log(c.maxWidth.toString());
      return Container(
        margin: widget.margin,
        height: cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: buildExactAssetImage(widget.backgroundImage),
              fit: BoxFit.cover),
          boxShadow: const [BoxShadow(blurRadius: 1, offset: Offset(1, 1))],
          color: widget.backgroundImage == null
              ? widget.backgroundColor
              : widget.backgroundColor,
          gradient: widget.backgroundGradient,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.secondComp
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 12, left: 16, bottom: 5),
                        // child: buildCurrencyText(widget.currency, widget.colors),
                        child: Image.asset(widget.companyLogo2 ?? '',
                            width: 50, height: 40),
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 12, left: 16, bottom: 5),
                        // child: buildCurrencyText(widget.currency, widget.colors),
                        child: Text(
                          widget.currency.toString(),
                          textScaler: TextScaler.noScaling,
                          style: TextStyle(
                              color: widget.colors,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      widget.title ?? "BODASURE",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 114, 186, 1),
                      ),
                    ),
                  ),
                ),

                /// Bank Logo
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 18),
                  // child: Text("issuer icon"),
                  child: Image.asset("assets/images/logo2.png",
                      width: 50, height: 50),
                ),
              ],
            ),

            /// Chip
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: EdgeInsets.only(left: 32, top: 10),
                child: widget.userProfile == null
                    ? Image(
                        image: widget.imagePkg == "1"
                            ? AssetImage("assets/bima/silver.png")
                            : AssetImage("assets/bima/gold.png"),
                        width: 75,
                        height: 75,
                      )
                    : waCommonCachedNetworkImage(
                        '${Environment.imageUrl}/${userImage}',
                        fit: BoxFit.cover,
                        height: context.height() * 0.1,
                        width: context.width() * 0.2,
                      ).cornerRadiusWithClipRRect(10),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 5),
              //   child:
              //       SvgPicture.asset(
              //     AppConstants.rfid,
              //     package: "Bima Sanlam",
              //     width: 32,
              //     height: 32,
              //   ),
              // )
            ]),
            const SizedBox(height: 5),

            const SizedBox(height: 3),

            /// Validity Date
            Column(children: [
              // const Text("MONTH/YEAR", style: TextStyle(fontSize: 11)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(width: 36),
                const Text(
                  "KUANZA : ",
                  textScaler: TextScaler.noScaling,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
                const SizedBox(width: 13),
                Text(widget.start,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(fontSize: 10)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(width: 36),
                const Text(
                  "KUISHA :",
                  textScaler: TextScaler.noScaling,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
                const SizedBox(width: 12),
                Text(widget.validity,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(fontSize: 10)),
              ])
            ]),
          ]),
          const SizedBox(height: 8),

          /// Holder's name
          Positioned(
            bottom: 10,
            left: 5,
            child: Container(
              alignment: Alignment.center,
              width: 120,
              height: 55,
              child: Text(
                '${widget.holder.split(' ').first}',

                textScaler: TextScaler.noScaling,
                style: const TextStyle(
                  fontFamily: 'Inconsolata',
                  fontWeight: FontWeight.w500,
                  shadows: [BoxShadow(blurRadius: 0.1, offset: Offset(0, 0))],
                  fontSize: 10,
                ).applyPackage,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          /// Card Network
          widget.companyLogo == ""
              ? SizedBox()
              : Positioned(
                  bottom: 2 /*cardNetwork.index == 1 ? -10 : 0*/,
                  right: 10,
                  //height: 45,
                  width: 60,
                  child: Image(
                    image: ExactAssetImage(
                      widget.companyLogo ?? "",
                    ),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
          widget.statusAppear
              ? Positioned(
                  top: cardHeight * 0.45,
                  left: cardWidth * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: widget.status
                        ? Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                            size: 32,
                          )
                        : (DateTime.parse(widget.validity)
                                .isAfter(DateTime.now())
                            ? Text(
                                "Inafanyiwa Kazi",
                                textScaler: TextScaler
                                    .noScaling, // For consistent scaling
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Imekwisha mda wake",
                                textScaler: TextScaler
                                    .noScaling, // For consistent scaling
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                  ),
                )
              : Container(),
        ]),
      );
    });
  }
}
