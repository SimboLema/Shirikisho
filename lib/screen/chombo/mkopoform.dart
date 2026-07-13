import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/global/appConstants.dart';
import 'package:shirikisho/providers/MkopoManagementProvider.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;

class MkopoForm extends StatefulWidget {
  const MkopoForm({super.key});

  @override
  State<MkopoForm> createState() => _MkopoFormState();
}

class _MkopoFormState extends State<MkopoForm> {
  // Text controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController tinNumberController = TextEditingController();
  final TextEditingController acounttController = TextEditingController();
  // late MKopoData vehicledata;

  final _formKey = GlobalKey<FormState>();
  // Variables to store file paths
  File? formYaDhamana;

  String? selectedItem; // Variable to hold the selected value
  String? selectedTawi;
  String? selectedBrand;
  List? vyombo;
  List? brands;
  // Method to pick a file
  Future<void> pickFile(Function(File) onFilePicked) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      onFilePicked(File(result.files.single.path!));
    }
  }

  Color screenColor = WAPrimaryColor;
  late AuthService authService;

  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var avatar = "/office/media/avatars/300-1.jpg";

  bool isWaiting = false;
  bool isLoading = false;

  final _storage = const FlutterSecureStorage();

  Future<void> getUserData() async {
    authService.getUser();

    var username = await _storage.read(key: 'full_name');
    var userphone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');

    var res = await _storage.read(key: 'vehicleTypes');
    var res2 = await _storage.read(key: 'brands');

    if (res != null) {
      List<dynamic> vehicles = jsonDecode(res);
      // print("usafiri ${vehicles}");
      setState(() {
        vyombo = vehicles;
      });
    }
    {
      List<dynamic> vehicles = [];
    }

    if (res2 != null) {
      List<dynamic> vehicle_brand = jsonDecode(res2);
      // print("usafiri ${vehicles}");
      setState(() {
        brands = vehicle_brand;
      });
    }
    {
      List<dynamic> vehicle_brand = [];
    }
    setState(
      () {
        nameController.text = username!;
        phoneController.text = userphone!;
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
    // print("vyomboo :: ${vyombo}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fomu ya Maombi ya Mkopo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Jina',
                    labelStyle: TextStyle(color: Colors.black87),
                    // errorText:
                    //     validateInputField(nameController.text, isRequired: true),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a user type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Namba ya simu',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    // errorText: validateInputField(phoneController.text,
                    //     isRequired: true),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tafadhali weka namba ya simu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: acounttController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Namba ya akaunti ya benki',
                    labelStyle: TextStyle(color: Colors.black87),
                    // errorText: validateInputField(acounttController.text),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tafadhalli jaza akaunti namba yako';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // vehicles== null?CircularProgressIndicator():
                DropdownButtonFormField<String>(
                  value: selectedItem,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Aina Ya Chombo',
                    labelStyle: TextStyle(color: Colors.black87),
                    // errorText: validateInputField(
                    //   selectedItem,
                    // ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue; // Update selected item

                      selectedBrand = null;
                    });
                  },
                  // items: AppConstants.items
                  //     .map<DropdownMenuItem<String>>((String value) {
                  //   return DropdownMenuItem<String>(
                  //     value: value,
                  //     child: Text(value),
                  //   );
                  // }).toList(),
                  items: vyombo!.map<DropdownMenuItem<String>>((vehicle) {
                    return DropdownMenuItem<String>(
                      value: vehicle['id'].toString(),
                      child: Text(vehicle['v_type_name']),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tafadhali cahgua aina ya chombo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedBrand,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Chagua Kampuni',
                    labelStyle: TextStyle(color: Colors.black87),
                    // errorText: validateInputField(
                    //   selectedBrand,
                    // ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBrand = newValue;
                    });
                  },
                  // items: selectedItem == null
                  //     ? []
                  //     : AppConstants.brandMap[selectedItem]!
                  //         .map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //             value: value, child: Text(value));
                  //       }).toList(),
                  items: selectedItem == null
                      ? [] // If no vehicle type is selected, show an empty list.
                      : brands!
                          .where((brand) =>
                              brand['vehicle_type_id'].toString() ==
                              selectedItem) // Filter brands based on selected vehicle type
                          .map<DropdownMenuItem<String>>((brand) {
                          return DropdownMenuItem<String>(
                            value: brand['id'].toString(),
                            child: Text(brand['brand_name']),
                          );
                        }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tafadhali chagua kampuni ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // _buildFileField(
                //   label: 'Form Ya Dhamana',
                //   file: formYaDhamana,
                //   onFilePicked: (file) {
                //     setState(() {
                //       formYaDhamana = file;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null) {
                //       return 'tafadhali weka fomu ya dhamani';
                //     }
                //     return null;
                //   },
                // ),
                _buildFileField(
                  label: 'Form Ya Dhamana',
                  file: formYaDhamana,
                  onFilePicked: (file) {
                    setState(() {
                      formYaDhamana = file;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'tafadhali weka fomu ya dhamani';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: WAPrimaryColor,
                            fixedSize: Size(160, 40)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sitisha',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: WAPrimaryColor,
                            fixedSize: Size(160, 40)),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          bool validate = _formKey.currentState!.validate();
                          print("validator :: ${validate}");

                          if (validate) {
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                isLoading = false;
                              });
                              _submitForm(isWaiting);
                            });
                          } else {
                            Future.delayed(Duration(seconds: 2), () {
                               setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        },
                        child: isLoading
                            ? SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Tuma',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileField({
    required String label,
    required File? file,
    required Function(File) onFilePicked,
    required String? Function(File?)? validator, // Accept a validator function
  }) {
    return FormField<File>(
      // Use FormField to trigger validation
      validator: validator,
      builder: (FormFieldState<File> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
                  onPressed: () => pickFile((file) {
                    onFilePicked(file);
                    state.didChange(file); // Update the state of the FormField
                  }),
                  child: const Text(
                    'Pakia Kiambatanisho',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                if (file != null)
                  Expanded(
                    child: Text(
                      file.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                if (file != null)
                  IconButton(
                    icon: const Icon(
                      Icons.verified,
                      color: WAPrimaryColor,
                    ),
                    onPressed: () {
                      // Open the PDF document using a viewer or an external app
                      // Example: Open using url_launcher or other package
                    },
                  ),
              ],
            ),
            if (state.hasError) // Display error if validation fails
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }

  void _submitForm(bool isWaiting) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text(
              "Muktasari wa Maombi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow("Jina:", nameController.text),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Namba ya Simu:", phoneController.text),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                      "Namba ya Akaunti ya Benki:", acounttController.text),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Aina ya Chombo:",
                      selectedItem ?? "Hujachagua aina ya chombo"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Kampuni:", selectedBrand ?? "chagua brand"),
                  const SizedBox(height: 16),
                  _buildSummaryFileField("Form Ya Dhamana", formYaDhamana),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Namba ya simu kwa malipo',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog on Sitisha
                },
                child: const Text(
                  'Sitisha',
                  style: TextStyle(color: WAPrimaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Navigator.of(context).pop(); // Close the dialog on Lipa
                  _processPayment(); // Custom method to process payment
                  setState(() {
                    isWaiting = true;
                  });

                  var data = {
                    "transaction_id": "TRX003",
                    "account_number": acounttController.text,
                    "vehicle_type_id": selectedItem,
                    "vehicle_id": selectedBrand,
                    // "file_url": await MultipartFile.fromFile(formYaDhamana!.path,
                    //     filename: formYaDhamana!.path),
                    'support_documents': [
                      // File(formYaDhamana!.path),
                      File(formYaDhamana!.path)
                    ],
                  };
                  print("Data to be sent to end point $data");
                  var result = await Provider.of<Mkopomanagementprovider>(
                          context,
                          listen: false)
                      .loanApplication(context, data);

                  print("results    $result");

                  if (result) {
                    setState(() {
                      isWaiting = false;
                    });

                    print("submit successfully");
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      isWaiting = false;
                    });
                    toasty(context, "Submit failed",
                        bgColor: Colors.red, textColor: Colors.white);

                    isWaiting = false;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WAPrimaryColor, // Payment button color
                ),
                child: isWaiting
                    ? SizedBox(
                        height: 8,
                        width: 8,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.white,
                        ))
                    : Text(
                        'Lipa',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          );
        });
      },
    );
    // }
  }

// Helper method to build summary rows
  Widget _buildSummaryRow(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

// Helper method to display file name in the summary
  Widget _buildSummaryFileField(String label, File? file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(file != null ? file.path.split('/').last : "Hakuna Kiambatanisho",
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

// Example method to process payment (this is a placeholder)
  void _processPayment() {
    print('Processing payment for ${phoneController.text}');
    // Add payment logic here
  }
}
