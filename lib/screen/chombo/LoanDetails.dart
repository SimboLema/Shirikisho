import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:shirikisho/screen/chombo/components/widgets.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/services/pdf_viewer.dart';
import 'package:shirikisho/utils/WAColors.dart'; // Import EasyStepper
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class LoanDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> loan;

  const LoanDetailsScreen({Key? key, required this.loan}) : super(key: key);

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  Color screenColor = WAPrimaryColor;
  late AuthService authService;
  var name = "";
  var phone = "";

  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var avatar = "/office/media/avatars/300-1.jpg";

  bool isWaiting = false;
  bool isLoading = false;

  final _storage = const FlutterSecureStorage();
  // Mapping vehicle_type_id to vehicle names
  Map<int, String> vehicleTypeMap = {
    1: 'Pikipiki',
    2: 'Bajaji',
    3: 'Guta',
  };

  Future<void> getUserData() async {
    authService.getUser();

    var username = await _storage.read(key: 'full_name');
    var userphone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');

    setState(
      () {
        name = username!;
        phone = userphone!;
        userImage = image!;
        userJacket = uniform!;
        isAdmin = isLeader! == 'true' ? true : false;
      },
    );
    // print("USER ::${name}");
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService();

    // Provider.of<Mkopomanagementprovider>(context, listen: false).getVehicles();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    int activeStep = getActiveStep(
        widget.loan['status']); // Determine active step based on loan status

    return Scaffold(
      appBar: AppBar(
        title: const Text("taarifa ya Mkopo"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Applicant Details Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Taarifa",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.person, color: WAPrimaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          // "Jina: ${widget.loan['applicant_name'] ?? 'John Doe'}",
                          "Jina: $name ",

                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: WAPrimaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          // "Namba Ya simu: ${widget.loan['phone'] ?? '+1234567890'}",
                          "Namba Ya simu: $phone",

                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.account_balance, color: WAPrimaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Namba ya akaunti: ${widget.loan['account_number'] ?? 'Not Available'}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.directions_car, color: WAPrimaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          // "Aina Chombo: ${widget.loan['vehicle_type_id'] ?? 'Not Available'}",
                          "Aina Chombo: ${vehicleTypeMap[widget.loan['vehicle_type_id']] ?? 'Not Available'}",

                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.date_range, color: WAPrimaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Tarehe ya Maombi: ${formattedDate(widget.loan['created_at'])}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // const Icon(Icons.date_range, color: WAPrimaryColor),
                      const SizedBox(width: 32),
                      // const SizedBox(width: 8),

                      Expanded(
                          child: Text(
                        widget.loan['status'].toString().toLowerCase() ==
                                'pending'
                            ? 'Unafanyiwa kazi'
                            : widget.loan['status'].toString().toLowerCase() ==
                                    'accepted'
                                ? 'Umekubaliwa'
                                : 'Umekataliwa', // The actual status text
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          color:
                              widget.loan['status'].toString().toLowerCase() ==
                                      'pending'
                                  ? Colors.orange // Color for pending
                                  : widget.loan['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'accepted'
                                      ? Colors.green // Color for accepted
                                      : Colors.red, // Color for rejected
                        ),
                      )),
                    ],
                  ),
                  if (widget.loan['status'] == 'accepted') ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: WAPrimaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Tarehe ya kukubaliwa: ${formattedDate(widget.loan['accepted_at'])}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Loan Progress Stepper
            const Text(
              "Maendeleo ya Mkopo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            EasyStepper(
              disableScroll: false,
              activeStep: activeStep,
              lineStyle: LineStyle(
                lineLength: 70,
                lineSpace: 0,
                lineType: LineType.normal,
                defaultLineColor: Colors.grey,
                finishedLineColor: WAPrimaryColor,
              ),
              activeStepTextColor: Colors.black87,
              finishedStepTextColor: Colors.black87,
              internalPadding: 0,
              showLoadingAnimation: false,
              stepRadius: 8,
              showStepBorder: false,
              steps: [
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          activeStep >= 0 ? WAPrimaryColor : Colors.white,
                    ),
                  ),
                  // title: 'Umepokelewa',
                  customTitle: Text(
                    "Umepokelewa",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          activeStep >= 1 ? WAPrimaryColor : Colors.white,
                    ),
                  ),
                  // title: 'Unafanyiwa Kazi',
                  customTitle: Text(
                    "Unafanyiwa Kazi",
                    style: TextStyle(fontSize: 10),
                  ),

                  topTitle: true,
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          activeStep >= 2 ? WAPrimaryColor : Colors.white,
                    ),
                  ),
                  // title: 'Tawi la kuchukua mkopo',
                  customTitle: Text(
                    "Tawi la kuchukua mkopo",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          activeStep >= 3 ? WAPrimaryColor : Colors.white,
                    ),
                  ),
                  // title: 'Mkopo umekamilika',
                  customTitle: Text(
                    "Mkopo umekamilika",
                    style: TextStyle(fontSize: 10),
                  ),

                  topTitle: true,
                ),
              ],
              onStepReached: (index) {
                // Set active step logic if required
              },
            ),
            const SizedBox(height: 24),

            // Support Documents Section
            if (widget.loan['support_documents'] != null &&
                widget.loan['support_documents'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kiambatanisho",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.loan['support_documents'].length,
                    itemBuilder: (context, index) {
                      final document = widget.loan['support_documents'][index];
                      return ListTile(
                        leading: const Icon(Icons.picture_as_pdf,
                            color: WAPrimaryColor),
                        title: Text(document['file_name']),
                        onTap: () async {
                          // Navigate to PDF viewer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerScreen(
                                fileUrl:
                                    "https://mfumo.shirikisho.co.tz/${document['file_url']}",
                                fileName: document['file_name'],
                              ),
                            ),
                          );
                          // Download the PDF and get the local file path
                        },
                      );
                    },
                  ),
                ],
              )
            else
              noAttachment()
          ],
        ),
      ),
    );
  }

  String formattedDate(String? dateString) {
    if (dateString == null) return 'Not Available';
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat.yMMMMd('en_US').add_jms();
    return formatter.format(dateTime);
  }

  int getActiveStep(String status) {
    switch (status) {
      case 'accepted':
        return 3; // Assuming 4 is the step for 'Mkopo umekamilika'
      case 'pending':
        return 2; // Assuming 2 is the step for 'Tawi la kuchukua mkopo'
      case 'processing':
        return 1; // Assuming 1 is the step for 'Unafanyiwa Kazi'
      default:
        return 0; // Default step for 'Umepokelewa'
    }
  }

  // Function to download and store the PDF locally
  Future<File?> _downloadPDF(String url) async {
    try {
      // Get the directory to store the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/sample.pdf';
      final file = File(filePath);

      // Download the file
      final response = await HttpClient().getUrl(Uri.parse(url));
      final downloadData = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(downloadData);
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print("Error downloading PDF: $e");
      return null;
    }
  }

  // Function to open the PDF with an external app
  Future<void> _openPDF(String filePath) async {
    final Uri fileUri = Uri.file(filePath);
    if (await canLaunchUrl(fileUri)) {
      await launchUrl(fileUri);
    } else {
      throw 'Could not open the PDF file.';
    }
  }
}
