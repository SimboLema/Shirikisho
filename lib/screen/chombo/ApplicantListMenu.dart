// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/global/http.dart';
import 'package:shirikisho/screen/chombo/ApplicationDetails.dart';
import 'package:shirikisho/utils/WAColors.dart';

class LoanRequestsWidget extends StatefulWidget {
  const LoanRequestsWidget({Key? key}) : super(key: key);

  @override
  _LoanRequestsWidgetState createState() => _LoanRequestsWidgetState();
}

class _LoanRequestsWidgetState extends State<LoanRequestsWidget> {
  int _selectedIndex = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Map<int, String> vehicleTypeMap = {
    1: 'Pikipiki',
    2: 'Bajaji',
    3: 'Guta',
  };
  List<Map<String, dynamic>> _pendingLoanList = [];
  List<Map<String, dynamic>> _acceptedLoanList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getRegionalApplications(); // Load data when the widget is initialized
  }

  Future<void> getRegionalApplications() async {
    var token = await _secureStorage.read(key: 'token');

    print('TOKEN: ${token}');

    setState(() {
      isLoading = true; // Start loading
    });

    try {
      var res = await ApiClientHttp(headers: <String, String>{
        'Authorization': 'Bearer $token',
      }).getRequest('api/region_manager_loan-applications');

      print('RES: ${res}');

      if (res != null && res['status'] == true) {
        // Casting the 'loans' list to List<Map<String, dynamic>>
        List<dynamic> loans = res['loans'];

        // Ensure each item is cast correctly to Map<String, dynamic>
        List<Map<String, dynamic>> pendingLoans = loans
            .where((loan) =>
                loan is Map<String, dynamic> && loan['status'] == 'pending')
            .cast<Map<String, dynamic>>()
            .toList();

        List<Map<String, dynamic>> acceptedLoans = loans
            .where((loan) =>
                loan is Map<String, dynamic> && loan['status'] == 'accepted')
            .cast<Map<String, dynamic>>()
            .toList();

        setState(() {
          _pendingLoanList = pendingLoans;
          _acceptedLoanList = acceptedLoans;
        });
        setState(() {
          isLoading = false; // Start loading
        });
      } else {
        setState(() {
          isLoading = false; // Start loading
        });
        throw Exception('Failed to load loans');
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false; // Start loading
      });

      if (e.toString().contains('FormatException')) {
        // Handle unexpected format error
        toasty(context,
            'Failed to load data. Please check your connection or try again later.');
      } else {
        // General error handling
        toasty(context, 'An error occurred: ${e.toString()}');
      }
    }
  }

  String formattedDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat.yMMMMd('en_US').add_jms();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maombi ya Mikopo'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: WAPrimaryColor),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? WAPrimaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Maombi Mapya',
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? WAPrimaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Mikopo iliopitishwa',
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
                const SizedBox(height: 20),
                _selectedIndex == 0
                    ? _pendingLoanList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: const Center(
                              child: Text(
                                'No new loan requests',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    _pendingLoanList.map<Widget>((request) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ApplicationDetailsPage(
                                            loan: request,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        title: Text(
                                          "Jina la Muombaji: ${request['user_id']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Aina ya Chombo: ${vehicleTypeMap[request['vehicle_type_id']]}"),
                                                
                                            Text(
                                                overflow: TextOverflow.ellipsis,
                                                "Umeombwa: ${formattedDate(request['created_at'])}"),
                                          ],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              'assets/images/shirikisho.png'), // Placeholder image
                                        ),
                                      ),
                                    ).paddingAll(8),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                    : _selectedIndex == 1
                        ? _acceptedLoanList.isEmpty
                            ? const Center(
                                child: Text(
                                  'No accepted loans',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    _acceptedLoanList.map<Widget>((request) {
                                  return InkWell(
                                    onTap: () {
                                      // Add your onTap functionality here
                                    },
                                    child: Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        title: Text(
                                          "Akaunti namba: ${request['account_number']}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Kiasi: ${request['amount']}"),
                                            Text(
                                              "Aina ya chombo:  ${vehicleTypeMap[request['vehicle_type_id']]}",
                                              overflow: TextOverflow.clip,
                                            ),
                                            // Text(
                                            //     "Status: ${request['status']}"),
                                            Row(
                                              children: [
                                                Text(
                                                  'Hali: ', // Label for the status
                                                  style: const TextStyle(
                                                    // fontSize: 10,
                                                    color: Colors
                                                        .black, // Fixed label color
                                                  ),
                                                ),
                                                Text(
                                                  request['status']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'pending'
                                                      ? 'Unafanyiwa kazi'
                                                    :request['status']
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              'accepted'
                                                          ? 'Umekubaliwa'
                                                          : 'Umekataliwa', // The actual status text
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    // fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: request['status']
                                                                .toString()
                                                                .toLowerCase() ==
                                                            'pending'
                                                        ? Colors
                                                            .orange // Color for pending
                                                        : request['status']
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
                                            request['updated_at'] == null
                                                ? const SizedBox()
                                                : Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    "Accepted At: ${formattedDate(request['updated_at'])}"),
                                          ],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              'assets/images/shirikisho.png'), // Placeholder image
                                        ),
                                      ),
                                    ).paddingAll(16),
                                  );
                                }).toList(),
                              )
                        : Container(),
              ],
            ),
    );
  }
}
