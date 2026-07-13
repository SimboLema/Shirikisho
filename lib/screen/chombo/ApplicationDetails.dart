import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/global/appConstants.dart';
import 'package:shirikisho/screen/chombo/components/widgets.dart';
import 'package:shirikisho/services/pdf_viewer.dart';
import 'package:shirikisho/utils/WAColors.dart';

class ApplicationDetailsPage extends StatefulWidget {
  final Map<String, dynamic> loan;
  const ApplicationDetailsPage({required this.loan});

  @override
  State<ApplicationDetailsPage> createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage> {
  TextEditingController _account = TextEditingController();
  String? selectedTawi;

  bool isLoading = false;
  Map<int, String> vehicleTypeMap = {
    1: 'Pikipiki',
    2: 'Bajaji',
    3: 'Guta',
  };
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Taarifa za Mkopo"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 25, left: 25, right: 25, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.03),
                              spreadRadius: 10,
                              blurRadius: 3,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 25, right: 20, left: 20),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [Icon(Icons.more_vert)],
                            // ),
                            Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://images.unsplash.com/photo-1531256456869-ce942a665e80?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTI4fHxwcm9maWxlfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: (size.width - 40) * 0.6,
                                  child: Column(
                                    children: [
                                      Text(
                                        "JOHN SMITH DOE",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "+255791XXXXXX",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "${widget.loan['account_number']}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 50),
                            // -------------------EXTRAS------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${vehicleTypeMap[widget.loan['vehicle_type_id']]}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: WAPrimaryColor),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Aina ya chombo",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          overflow: TextOverflow.clip,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 0.5,
                                  height: 40,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${widget.loan['amount']}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: WAPrimaryColor),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Kiasi",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          overflow: TextOverflow.clip,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Viambatanisho",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: WAPrimaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (widget.loan['support_documents'].isNotEmpty)
                            ...widget.loan['support_documents']
                                .map<Widget>((doc) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfViewerScreen(
                                        fileName: doc['file_name'],
                                        fileUrl:"http://file.itl.co.tz/z.htm?0=181839Nr8g"
                                            // "${AppConstants.apiBaseUrl}${doc['file_url']}",
                                      ),
                                    ),
                                  );
                                },
                                child: pdfDocuments(
                                    size, doc['file_name'], doc['file_url']),
                              );
                            }).toList()
                          else
                            noAttachment(),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedTawi,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Tawi la Kupata Mkopo',
                              labelStyle: TextStyle(color: Colors.black87),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTawi = newValue; // Update selected item
                              });
                            },
                            items: AppConstants.matawi
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'tafadhali chagua kampuni ';
                              }
                              return null;
                            },
                          ).paddingAll(32),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: WAPrimaryColor,
                        fixedSize: Size(120, 40)),
                    onPressed: () {
                      // Decline action
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Rudi nyuma ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: WAPrimaryColor,
                        fixedSize: Size(120, 40)),
                    onPressed: () async {
                      // Accept action
                      setState(() {
                        isLoading = true;
                      });

                      if (selectedTawi == null) {
                        // Show a message if no branch is selected
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            isLoading = false;
                            toast('Tafadhali chagua tawi', bgColor: Colors.red);
                          });
                        });
                      } else {
                        // Accept action if branch is selected
                        // Your submit logic here
                        Future.delayed(Duration(seconds: 3), () {
                          setState(() {
                            isLoading = false;
                          });
                          toast('Maombi yamethibitshwa', bgColor: Colors.green);

                          Navigator.pop(context);
                        });
                      }
                    },
                    child: isLoading
                        ? Container(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            overflow: TextOverflow.ellipsis,
                            'Kubali',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
