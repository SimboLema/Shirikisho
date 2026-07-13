import 'package:flutter/material.dart';
import 'package:shirikisho/utils/WAColors.dart';

const Color primary = Color(0xfff2f9fe);
const Color secondary = Color(0xFFdbe4f3);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;
const Color red = Color(0xFFec5766);
const Color green = Color(0xFF43aa8b);
const Color blue = Color(0xFF28c2ff);
const Color buttoncolor = Color(0xff3e4784);
const Color mainFontColor = Color(0xff565c95);
const Color arrowbgColor = Color(0xffe4e9f7);

Widget pdfDocuments(
  size,
  file_name,
  file_path
) {
  return Row(
    children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.only(
            top: 20,
            left: 25,
            right: 25,
          ),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.03),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: arrowbgColor,
                    borderRadius: BorderRadius.circular(15),
                    // shape: BoxShape.circle
                  ),
                  child: Center(child: Icon(Icons.picture_as_pdf_rounded)),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    width: (size.width - 90) * 0.7,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$file_name",
                            style: TextStyle(
                                fontSize: 12,
                                color: black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Sending Payment to Clients",
                            style: TextStyle(
                                fontSize: 12,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Pitia",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 8,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
Widget coverNoteDocuments({size, file_name, file_path}) {
  return Row(
    children: [
      Expanded(
        child: Container(
          
          margin: EdgeInsets.only(
            top: 20,
            left: 5,
            right: 5,
          ),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.03),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    // color: arrowbgColor,

                    borderRadius: BorderRadius.circular(15),
                    // shape: BoxShape.circle
                  ),
                  child: Center(child: Icon(Icons.picture_as_pdf_sharp,
                  color: WAPrimaryColor,
                  )),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    width: (size.width - 90) * 0.7,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$file_name",
                            textScaler: TextScaler.noScaling,

                            style: TextStyle(
                                fontSize: 12,
                                color: black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Nakala ya uthibitisho wa bima",
                            textScaler: TextScaler.noScaling,
                            style: TextStyle(
                                fontSize: 12,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Pakua",
                          textScaler: TextScaler.noScaling,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 8,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget noAttachment() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.grey.shade100, // Light background color
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Row(
      children: [
        Icon(
          Icons.warning_amber_rounded, // Icon to indicate no attachment
          color: Colors.orange.shade700,
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Hakuna kiambatanisho kilichopatikana.", // No attachment message
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87, // Darker text color for contrast
              fontWeight: FontWeight.w500, // Slightly bold text for emphasis
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget applicationListItem(String name, String Sccount,String amount, D ) {
//   return Card(
//     elevation: 3,
//     margin: const EdgeInsets.symmetric(vertical: 8),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: ListTile(
//       contentPadding: const EdgeInsets.all(16),
//       title: Text(
//         "Jina la Muombaji: ${name}",
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Kiasi: ${amount}"),
//           Text("Aina ya chombo: ${request['vehicle_type_id']}"),
//           Text("Status: ${request['status']}"),
//           request['updated_at'] == null
//               ? const SizedBox()
//               : Text("Accepted At: ${formattedDate(request['updated_at'])}"),
//         ],
//       ),
//       leading: CircleAvatar(
//         backgroundColor: Colors.white,
//         backgroundImage:
//             AssetImage('assets/images/shirikisho.png'), // Placeholder image
//       ),
//     ),
//   );
// }
