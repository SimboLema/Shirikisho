// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/utils/WAColors.dart';

class RequestMkopoForm extends StatefulWidget {
  const RequestMkopoForm({super.key});

  @override
  State<RequestMkopoForm> createState() => _RequestMkopoFormState();
}

class _RequestMkopoFormState extends State<RequestMkopoForm> {
  int _activeStepIndex = 0;
  String? _selectedRegion;
  String? _selectedRegion2;

  String? _selectedPermitType;
  String? _selectedAnimalType;

  TextEditingController name = TextEditingController();
  TextEditingController transport = TextEditingController();

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController total = TextEditingController();

  var userId;

  var userrid;

  Color screenColor = WAPrimaryColor;
  late AuthService authService;
  var userName = "";
  var userPhone = "";
  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var avatar = "/office/media/avatars/300-1.jpg";

  final _storage = const FlutterSecureStorage();

  Future<void> getUserData() async {
    authService.getUser();

    var username = await _storage.read(key: 'full_name');
    var userphone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');

    print(
        "object:: ${username}   ${userphone}  ${uniform}  ${image}  ${isLeader}");

    setState(
      () {
        userImage = image!;
        userJacket = uniform!;
        isAdmin = isLeader! == 'true' ? true : false;

        name.text = username!;
        phone.text = userphone!;
      },
    );
    // print("USER ::${name}");
  }

  // File paths for document uploads
  String? fomu;
  String? documentPath2;
  String? documentPath3;
  String? documentPath4;
  String? documentPath5;

  Future<void> pickDocument(int documentNumber) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        switch (documentNumber) {
          case 1:
            fomu = result.files.single.path;
            break;
          case 2:
            documentPath2 = result.files.single.path;
            break;
          case 3:
            documentPath3 = result.files.single.path;
            break;
          case 4:
            documentPath4 = result.files.single.path;
            break;
          case 5:
            documentPath5 = result.files.single.path;
            break;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(
            'Taarifa za Mteja',
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontFamily: 'Poppins', letterSpacing: 2),
          ),
          content: Container(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jina Kamili',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,

                  // obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Namba ya Simu',
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text(
            'Viambatanisho',
            style: TextStyle(
              fontFamily: 'Poppins',
              letterSpacing: 2,
            ),
          ),
          content: Container(
            child: Column(
              children: [
                _buildDocumentUploadField(1, fomu),
                const SizedBox(height: 8),
                _buildDocumentUploadField(2, documentPath2),
                const SizedBox(height: 8),
                _buildDocumentUploadField(3, documentPath3),
                const SizedBox(height: 8),
                _buildDocumentUploadField(4, documentPath4),
                const SizedBox(height: 8),
                _buildDocumentUploadField(5, documentPath5),
              ],
            ),
          ),
        ),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text(
              'Hakiki Taarifa',
              style: TextStyle(
                fontFamily: 'Poppins',
                letterSpacing: 2,
              ),
            ),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${name.text}'),
                Text('Phone : ${phone.text}'),
              ],
            )))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fomu ya Kuomba Mkopo wa Chombo"),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_activeStepIndex < (stepList().length - 1)) {
            setState(() {
              _activeStepIndex += 1;
            });
          } else {
            print('Submited');
            var data = {
              "customer": userId,
              "livestock_number": total.text,
              "permit_typec": _selectedPermitType,
              "transport": transport.text ?? '',
              "issued_at": DateTime.now().toIso8601String()
            };
            print("data:: ${data}");

            // var result =
            //     Provider.of<ServiceManagementProvider>(context, listen: false)
            //         .createPermit(data);
            var result = true;
            if (result == true) {
              print("Succesfully");
            } else {
              print("Failed");
            }
            Navigator.pop(context);
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }

          setState(() {
            _activeStepIndex -= 1;
          });
        },
        onStepTapped: (int index) {
          setState(() {
            _activeStepIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDocumentUploadField(int documentNumber, String? documentPath) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => pickDocument(documentNumber),
            child: Text(documentPath != null
                ? 'Document $documentPath Selected'
                : 'Upload Document $documentNumber',
                textScaler: TextScaler.noScaling,
                ),
          ),
        ),
        if (documentPath != null) Icon(Icons.check_circle, color: Colors.green),
      ],
    );
  }
}
