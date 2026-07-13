// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:intl/intl.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:shirikisho/screen/bimachombo/components/SummaryWidgets.dart';
// import 'package:shirikisho/utils/WAColors.dart';
// import 'package:shirikisho/utils/widgets/customreceipt.dart';

// class ReceiptDialog extends StatefulWidget {
//   @override
//   _ReceiptDialogState createState() => _ReceiptDialogState();
// }

// class _ReceiptDialogState extends State<ReceiptDialog> {
//   GlobalKey _repaintBoundaryKey = GlobalKey();

//   ScreenshotController screenshotController = ScreenshotController();

//   // Format the DateTime and return a formatted string
//   String _formatDate(DateTime dateTime) {
//     return DateFormat("MMM dd, yyyy 'at' HH:mm:ss").format(dateTime);
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.cancel_outlined,
//                     color: Colors.grey,
//                   ))),
//           // 2.height,
//           risiti(),
//         ],
//       ),
//       //   child: _getTicketReceiptView(),
//     );
//   }

//   Widget risiti() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // 10.height,
//             Image.asset(
//               "assets/animated/verified2.gif",
//               height: 100.0,
//               width: 100.0,
//             ),
//             4.height,
//             Text(
//               "Malipo yamekamilika",
//               style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "Tsh 25,000",
//               style: TextStyle(
//                   fontSize: 32,
//                   color: WAPrimaryColor,
//                   fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "TID: 181175522924",
//                   style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 verticalDivider(24),
//                 Text(
//                   // "Jan 16, 2025 at 10:15:44",
//                   _formatDate(DateTime.now()),
//                   style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             Divider(
//               color: Colors.grey.shade200,
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Kutoka",
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.normal),
//                   ),
//                   Text(
//                     "George Mushi",
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: WAPrimaryColor,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "0719401594",
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.normal),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               color: Colors.grey.shade200,
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Kwenda",
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.normal),
//                   ),
//                   Text(
//                     "KMJ Finance",
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: WAPrimaryColor,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               color: Colors.grey.shade200,
//             ),
//             10.height,
//             financerWidget(),
//             10.height,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () async {
//                     var result;
//                     await screenshotController
//                         .captureFromWidget(risiti())
//                         .then((bytes) {
//                       result = saveImage(bytes);
//                       print("result incoming:: ${result}");

//                       // if (jsonDecode(result)['isSuccess']) {
//                       toasty(context,
//                           "Risiti yako imehifadhiwa Kikamilifu kwenye Matunzio yako ya picha.",
//                           bgColor: Colors.green,
//                           textColor: Colors.white,
//                           gravity: ToastGravity.BOTTOM,
//                           duration: Duration(seconds: 5));
//                       // } else {

//                       // }
//                     }).catchError((onError) {
//                       print("error from capture:: $onError");
//                       toasty(
//                           context, "Hakuna Matumizi ya Picha yaliyohifadhiwa.",
//                           bgColor: Colors.orange,
//                           textColor: Colors.white,
//                           gravity: ToastGravity.BOTTOM,
//                           duration: Duration(seconds: 5));
//                     });
//                   },
//                   icon: Icon(
//                     Icons.download,
//                     color: WAPrimaryColor, // Blue icon color
//                   ),
//                   label: Text(
//                     "Pakua",
//                     style: TextStyle(color: WAPrimaryColor), // Blue text color
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white, // Button background color
//                     foregroundColor: WAPrimaryColor, // Text and icon color
//                     side: BorderSide(color: WAPrimaryColor), // Blue border
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(12), // Rounded corners
//                     ),
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     toasty(
//                       context,
//                       "coming Soon",
//                       bgColor: Colors.white,
//                       textColor: Colors.grey,
//                     );
//                     // print("Share button clicked");
//                   },
//                   icon: Icon(
//                     Icons.share,
//                     color: WAPrimaryColor, // Blue icon color
//                   ),
//                   label: Text(
//                     "Sambaza",
//                     style: TextStyle(color: WAPrimaryColor), // Blue text color
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white, // Button background color
//                     foregroundColor: WAPrimaryColor, // Text and icon color
//                     side: BorderSide(color: WAPrimaryColor), // Blue border
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(12), // Rounded corners
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> saveImage(Uint8List bytes) async {
//     var fileName = 'Receipt ::${DateTime.now().millisecondsSinceEpoch}';
//     await Permission.storage.request();

//     final result = await ImageGallerySaver.saveImage(bytes, name: fileName);
//     // print("result saved:: $result");
//     if (result['isSuccess']) {
//       // print("result saved:: $result");
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Widget risiti2() {
//     return MastraTicketView(
//       backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//       backgroundColor: WAPrimaryColor,
//       contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
//       triangleAxis: Axis.vertical,
//       borderRadius: 6,
//       // drawDivider: true,
//       trianglePos: .5,
//       circleDash: true,
//       drawArc: true,
//       // dividerPadding: 5,
//       dividerColor: Color(0xFF8F1299),
//       dashWidth: 5,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               10.height,
//               Image.asset(
//                 "assets/animated/verified2.gif",
//                 height: 125.0,
//                 width: 125.0,
//               ),
//               20.height,
//               Text(
//                 "Mixx by Yas",
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               // mitandaoWidget(),
//               Text(
//                 "Successful transfer of",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "Tsh 25,000",
//                 style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 "TID: 181175522924 | Jan 16, 2025 at 10:15:44",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Sent From: Kibubu Wallet",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "Sent To: Main Wallet",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     // onPressed: _saveScreenshot,
//                     onPressed: () async {
//                       await screenshotController
//                           .captureFromWidget(risiti())
//                           .then((bytes) {
//                         saveImage(bytes);
//                       }).catchError((onError) {
//                         print("error from capture:: $onError");
//                       });
//                     },
//                     icon: Icon(Icons.download),
//                     label: Text("Download"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.share),
//                     label: Text("Share"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _getTicketReceiptView() {
//   return MastraTicketView(
//     backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//     backgroundColor: Color(0xFF8F1299),
//     contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
//     triangleAxis: Axis.vertical,
//     borderRadius: 6,
//     drawDivider: true,
//     trianglePos: .5,
//     circleDash: true,
//     drawArc: true,
//     dividerPadding: 5,
//     dividerColor: Color(0xFF8F1299),
//     dashWidth: 5,
//     child: Container(
//       child: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: Container(
//               padding: EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Text(
//                         'DRAKE',
//                         style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700),
//                       ),
//                       Expanded(child: Container()),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Price: ',
//                               style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                             TextSpan(
//                               text: '\$15.00',
//                               style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 14),
//                   Text(
//                     'VR Tickets, General Admission',
//                     style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300),
//                   ),
//                   SizedBox(height: 14),
//                   Text(
//                     'Madison Square Garden, NY',
//                     style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300),
//                   ),
//                   SizedBox(height: 14),
//                   Text(
//                     'November 30,2020, 7:00PM',
//                     style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 14),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Price: ',
//                           style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         TextSpan(
//                           text: '\$15.00',
//                           style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 30),
//               child: Image.asset('assets/qr_placeholder.png'),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget verticalDivider(double? height) {
//   return Container(
//     height: height ?? 48,
//     // color: Colors.grey,
//     child: VerticalDivider(),
//   );
// }
