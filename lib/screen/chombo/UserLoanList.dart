import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shirikisho/screen/chombo/LoanDetails.dart';
import 'package:shirikisho/utils/WAColors.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({Key? key}) : super(key: key);

  static String routeName = "/loan";

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  List<dynamic> _loanList = []; // To hold the fetched loan data
  bool _isLoading = true; // To handle loading state
  bool _isError = false; // To handle error state
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Map<int, String> vehicleTypeMap = {
    1: 'Pikipiki',
    2: 'Bajaji',
    3: 'Guta',
  };

  // Fetch loan applications from the API
  Future<void> _fetchLoanApplications() async {
    var token = await _secureStorage.read(key: 'token');

    print('TOKEN: ${token}');

    final url =
        Uri.parse('https://mfumo.shirikisho.co.tz/api/loan-applications');

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _loanList = responseData['data']; // Set the data from API
          _isLoading = false; // Loading complete
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLoanApplications(); // Fetch loan applications on screen load
  }

  // Format date function
  String formattedDate(String? dateString) {
    if (dateString == null) return 'Not Available';
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat.yMMMMd('en_US').add_jms();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mikopo yako",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: WAPrimaryColor,
            )) // Show loading indicator
          : _isError
              ? const Center(child: Text('Failed to load loan applications'))
              : _loanList.isEmpty
                  ? const Center(child: Text('Hauna Mkopo wowote'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _loanList.length,
                      itemBuilder: (context, index) {
                        var loan = _loanList[index];
                        return InkWell(
                          onTap: () {
                            // Navigate to Loan Details screen with the selected loan data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoanDetailsScreen(loan: loan),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              // height: context.height()*0.15,
                              height: 100,
                              child: Stack(
                                children: [
                                  // Background image with some transparency
                                  Center(
                                    child: Opacity(
                                      opacity: 0.1, // Adjust opacity here
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            15), // Match card border radius
                                        child: Image.asset(
                                          'assets/images/crdb.png', // Your logo image path
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content of the card
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            leading: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/shirikisho.png'),
                                                ),
                                              ],
                                            ),
                                            title: Text(
                                              "Akaunti ya Benki: ${loan['account_number']}",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // const SizedBox(
                                                //     height: 10), // Add space
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Hali: ', // Label for the status
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors
                                                            .black, // Fixed label color
                                                      ),
                                                    ),
                                                    Text(
                                                      loan['status']
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              'pending'
                                                          ? 'Unafanyiwa kazi'
                                                          : loan['status']
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  'accepted'
                                                              ? 'Umekubaliwa'
                                                              : 'Umekataliwa', // The actual status text
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: loan['status']
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                'pending'
                                                            ? Colors
                                                                .orange // Color for pending
                                                            : loan['status']
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    'accepted'
                                                                ? Colors
                                                                    .green // Color for accepted
                                                                : Colors
                                                                    .red, // Color for rejected
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Text(
                                                  "Gharama za Maombi: ${loan['amount']}",
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  "Tarehe ya maombi: ${formattedDate(loan['created_at'])}",
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // child: Card(

                          //   elevation: 5,
                          //   margin: const EdgeInsets.symmetric(
                          //       vertical: 8, horizontal: 16),
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(12.0),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         ListTile(
                          //           leading: CircleAvatar(
                          //             radius: 24,
                          //             backgroundColor: Colors.white,
                          //             backgroundImage: AssetImage(
                          //                 'assets/images/shirikisho.png'),
                          //           ),
                          //           // Loan amount and status
                          //           title: Text(
                          //             "Akaunti ya Benki: ${loan['account_number']}",
                          //             style: const TextStyle(
                          //               fontSize: 12,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           subtitle: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               const SizedBox(height: 10), // Add space
                          //               // Display additional details
                          //               Text(
                          //                 "Status: ${loan['status']}",
                          //                 style: const TextStyle(fontSize: 12,
                          //                 overflow: TextOverflow.ellipsis

                          //                 ),
                          //               ),
                          //               Text(
                          //                 "Gharama za Maombi: ${loan['amount']}",
                          //                 style: const TextStyle(fontSize: 12,
                          //                 overflow: TextOverflow.ellipsis

                          //                 ),
                          //               ),
                          //               Text(
                          //                 "Tarehe ya maombi: ${formattedDate(loan['created_at'])}",
                          //                 style: const TextStyle(fontSize: 12,
                          //                 overflow: TextOverflow.ellipsis
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        );
                      },
                    ),
    );
  }
}
