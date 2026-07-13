import 'package:flutter/material.dart';
import '../../model/license_application_draft.dart';
import '../../model/la_option.dart';
import '../../latraServices/latra_api_service.dart';
import '../../latraServices/la_config.dart';
import '../../utils/widgets/la_progress_bar.dart';

// All 5 application steps in ONE screen/class, swapped via an internal
/// step index instead of separate pushed pages. Bottom bar has Back/Next,
/// last step shows Submit.
class LatraScreen extends StatefulWidget {
  static String tag = '/LatraScreen';
 
  /// Needed for the service-types lookup on the License Details step.
  /// Defaults to LAConfig.agentUid — override only if a different agent
  /// UID needs to be used for this particular application.
  final String agentUid;
 
  const LatraScreen({Key? key, this.agentUid = LAConfig.agentUid}) : super(key: key);
 
  @override
  LatraScreenState createState() => LatraScreenState();
}
 
class LatraScreenState extends State<LatraScreen> {
  late LatraApiService latraApi;
  final draft = LicenseApplicationDraft();
 
  static const _stepLabels = [
    'Vehicle Info',
    'Location',
    'License Details',
    'Contact Person',
    'Review & Submit',
  ];
 
  int currentStep = 0; // 0..4
 
  // --- Step 1 controllers ---
  final _vehicleFormKey = GlobalKey<FormState>();
  late TextEditingController chassisCtrl;
  late TextEditingController regNoCtrl;
  late TextEditingController coverNoteCtrl;
 
  // --- Step 3 controller ---
  final _seatingCtrl = TextEditingController(text: '4');
 
  // --- Step 4 controllers ---
  final _contactFormKey = GlobalKey<FormState>();
  late TextEditingController firstNameCtrl;
  late TextEditingController middleNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
 
  // --- Step 5 ---
  bool submitting = false;
 
  // --- Lookup data ---
  bool loadingRegions = true, loadingDistricts = false, loadingStations = false;
  bool loadingLicenseTypes = true, loadingDurations = false, loadingServiceTypes = false;
  bool loadingCountries = true;
  String? error;
 
  List<LAOption> regions = [];
  List<LAOption> districts = [];
  List<LAOption> stations = [];
  List<LAOption> licenseTypes = [];
  List<LAOption> durations = [];
  List<LAOption> serviceTypes = [];
  List<LAOption> countries = [];
 
  LAOption? selectedRegion;
  LAOption? selectedDistrict;
  LAOption? selectedStation;
  LAOption? selectedLicenseType;
  LAOption? selectedDuration;
  LAOption? selectedServiceType;
  LAOption? selectedCountry;
 
  @override
  void initState() {
    super.initState();
    latraApi = LAConfig.buildService();
 
    chassisCtrl = TextEditingController();
    regNoCtrl = TextEditingController();
    coverNoteCtrl = TextEditingController();
    firstNameCtrl = TextEditingController();
    middleNameCtrl = TextEditingController();
    lastNameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
 
    draft.natureOfApplication = 'NEW';
 
    _loadRegions();
    _loadLicenseTypes();
    _loadCountries();
  }
 
  @override
  void dispose() {
    chassisCtrl.dispose();
    regNoCtrl.dispose();
    coverNoteCtrl.dispose();
    _seatingCtrl.dispose();
    firstNameCtrl.dispose();
    middleNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }
 
  // ---------------- Lookup loading ----------------
 
  Future<void> _loadRegions() async {
    setState(() => loadingRegions = true);
    try {
      final res = await latraApi.getRegions();
      setState(() => regions = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load regions: $e');
    } finally {
      setState(() => loadingRegions = false);
    }
  }
 
  Future<void> _onRegionSelected(LAOption? region) async {
    setState(() {
      selectedRegion = region;
      selectedDistrict = null;
      selectedStation = null;
      districts = [];
      stations = [];
      draft.regionUid = region?.uid;
      draft.regionName = region?.name;
      draft.districtUid = null;
      draft.stationUid = null;
    });
    if (region == null) return;
 
    setState(() => loadingDistricts = true);
    try {
      final res = await latraApi.getDistricts(region.uid);
      setState(() => districts = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load districts: $e');
    } finally {
      setState(() => loadingDistricts = false);
    }
  }
 
  Future<void> _onDistrictSelected(LAOption? district) async {
    setState(() {
      selectedDistrict = district;
      selectedStation = null;
      stations = [];
      draft.districtUid = district?.uid;
      draft.districtName = district?.name;
      draft.stationUid = null;
    });
    if (district == null) return;
 
    setState(() => loadingStations = true);
    try {
      final res = await latraApi.getStations(district.uid);
      setState(() => stations = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load stations: $e');
    } finally {
      setState(() => loadingStations = false);
    }
  }
 
  void _onStationSelected(LAOption? station) {
    setState(() {
      selectedStation = station;
      draft.stationUid = station?.uid;
      draft.stationName = station?.name;
    });
  }
 
  Future<void> _loadLicenseTypes() async {
    setState(() => loadingLicenseTypes = true);
    try {
      final res = await latraApi.getLicenseTypes();
      setState(() => licenseTypes = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load license types: $e');
    } finally {
      setState(() => loadingLicenseTypes = false);
    }
  }
 
  Future<void> _loadCountries() async {
    setState(() => loadingCountries = true);
    try {
      final res = await latraApi.getCountries();
      setState(() => countries = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load countries: $e');
    } finally {
      setState(() => loadingCountries = false);
    }
  }
 
  Future<void> _onLicenseTypeSelected(LAOption? type) async {
    setState(() {
      selectedLicenseType = type;
      selectedDuration = null;
      selectedServiceType = null;
      durations = [];
      serviceTypes = [];
      draft.licenseTypeUid = type?.uid;
      draft.licenseTypeName = type?.name;
      draft.licenseDurationUid = null;
      draft.serviceTypeUid = null;
    });
    if (type == null) return;
 
    setState(() {
      loadingDurations = true;
      loadingServiceTypes = true;
    });
    try {
      final res = await latraApi.getLicenseDurations(type.uid);
      setState(() => durations = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load durations: $e');
    } finally {
      setState(() => loadingDurations = false);
    }
 
    try {
      final res = await latraApi.getServiceTypes(type.uid, widget.agentUid);
      setState(() => serviceTypes = LAOption.parseList(res));
    } catch (e) {
      setState(() => error = 'Could not load service types: $e');
    } finally {
      setState(() => loadingServiceTypes = false);
    }
  }
 
  // ---------------- Navigation ----------------
 
  bool get _canProceed {
    switch (currentStep) {
      case 0:
        return draft.vehicleStepComplete;
      case 1:
        return draft.locationStepComplete;
      case 2:
        return draft.licenseStepComplete;
      case 3:
        return draft.contactStepComplete;
      case 4:
        return draft.userDeclaration;
      default:
        return false;
    }
  }
 
  void _goNext() {
    if (currentStep == 0 && !_vehicleFormKey.currentState!.validate()) return;
    if (currentStep == 3 && !_contactFormKey.currentState!.validate()) return;
 
    if (currentStep == 0) {
      draft.chassisNumber = chassisCtrl.text.trim();
      draft.vehicleRegistrationNumber = regNoCtrl.text.trim();
      draft.tiraCoverNoteNumber =
          coverNoteCtrl.text.trim().isEmpty ? null : coverNoteCtrl.text.trim();
    } else if (currentStep == 2) {
      draft.seatingCapacity = int.tryParse(_seatingCtrl.text) ?? 0;
      draft.registrationCountryUid = selectedCountry?.uid;
      draft.registrationCountryName = selectedCountry?.name;
    } else if (currentStep == 3) {
      draft.contactFirstName = firstNameCtrl.text.trim();
      draft.contactMiddleName =
          middleNameCtrl.text.trim().isEmpty ? null : middleNameCtrl.text.trim();
      draft.contactLastName = lastNameCtrl.text.trim();
      draft.contactEmail = emailCtrl.text.trim();
      draft.contactPhoneNumber = phoneCtrl.text.trim();
      draft.contactDistrictUid ??= draft.districtUid;
    }
 
    if (!_canProceed) return;
 
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      _submit();
    }
  }
 
  void _goBack() {
    if (currentStep > 0) setState(() => currentStep--);
  }
 
  Future<void> _submit() async {
    setState(() {
      submitting = true;
      error = null;
    });
    try {
      final result = await latraApi.submitApplication(draft.toApiPayload());
      if (!mounted) return;
 
      if (result['success'] == true) {
        final uid = result['licenseApplication']?['uid']?.toString() ?? '';
        _showSuccessDialog(uid);
      } else {
        setState(() => error = result['message']?.toString() ??
            'Application was not accepted. Please try again.');
      }
    } catch (e) {
      setState(() => error = 'Submission failed: $e');
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }
 
  void _showSuccessDialog(String applicationUid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Application Submitted'),
        content: Text(applicationUid.isNotEmpty
            ? 'Your license application was submitted successfully.\nReference: $applicationUid'
            : 'Your license application was submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
 
  // ---------------- UI ----------------
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New License Application')),
      body: SafeArea(
        child: Column(
          children: [
            LAProgressBar(
              currentStep: currentStep + 1,
              stepLabel: _stepLabels[currentStep],
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            Expanded(child: SingleChildScrollView(child: _buildStep())),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }
 
  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _buildVehicleStep();
      case 1:
        return _buildLocationStep();
      case 2:
        return _buildLicenseStep();
      case 3:
        return _buildContactStep();
      case 4:
        return _buildReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }
 
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: submitting ? null : _goBack,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Back'),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: submitting ? null : _goNext,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(currentStep < 4 ? 'Next' : 'Submit Application'),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  // --- Step 1: Vehicle ---
  Widget _buildVehicleStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _vehicleFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Application Type', style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('NEW'),
                    value: 'NEW',
                    groupValue: draft.natureOfApplication,
                    onChanged: (v) => setState(() => draft.natureOfApplication = v),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('RENEW'),
                    value: 'RENEW',
                    groupValue: draft.natureOfApplication,
                    onChanged: (v) => setState(() => draft.natureOfApplication = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: chassisCtrl,
              decoration: const InputDecoration(
                  labelText: 'Chassis Number', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: regNoCtrl,
              decoration: const InputDecoration(
                  labelText: 'Vehicle Registration Number',
                  border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: coverNoteCtrl,
              decoration: const InputDecoration(
                  labelText: 'TIRA Cover Note Number (optional)',
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
 
  // --- Step 2: Location ---
  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _dropdown('Region', loadingRegions, regions, selectedRegion, _onRegionSelected),
          const SizedBox(height: 16),
          _dropdown('District', loadingDistricts, districts, selectedDistrict,
              _onDistrictSelected,
              enabled: selectedRegion != null),
          const SizedBox(height: 16),
          _dropdown('Station', loadingStations, stations, selectedStation,
              _onStationSelected,
              enabled: selectedDistrict != null),
        ],
      ),
    );
  }
 
  // --- Step 3: License Details ---
  Widget _buildLicenseStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _dropdown('License Type', loadingLicenseTypes, licenseTypes,
              selectedLicenseType, _onLicenseTypeSelected),
          const SizedBox(height: 16),
          _dropdown('License Duration', loadingDurations, durations, selectedDuration,
              (v) => setState(() {
                    selectedDuration = v;
                    draft.licenseDurationUid = v?.uid;
                    draft.licenseDurationName = v?.name;
                  }),
              enabled: selectedLicenseType != null),
          const SizedBox(height: 16),
          _dropdown('Service Type', loadingServiceTypes, serviceTypes,
              selectedServiceType,
              (v) => setState(() {
                    selectedServiceType = v;
                    draft.serviceTypeUid = v?.uid;
                    draft.serviceTypeName = v?.name;
                  }),
              enabled: selectedLicenseType != null),
          const SizedBox(height: 16),
          _dropdown('Registration Country', loadingCountries, countries,
              selectedCountry, (v) => setState(() => selectedCountry = v)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _seatingCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
                labelText: 'Seating Capacity', border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
 
  // --- Step 4: Contact Person ---
  Widget _buildContactStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: firstNameCtrl,
              decoration: const InputDecoration(
                  labelText: 'First Name', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: middleNameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Middle Name (optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Last Name', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Male'),
                    value: 'MALE',
                    groupValue: draft.contactGender,
                    onChanged: (v) => setState(() => draft.contactGender = v),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Female'),
                    value: 'FEMALE',
                    groupValue: draft.contactGender,
                    onChanged: (v) => setState(() => draft.contactGender = v),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Phone Number (e.g. 255XXXXXXXXX)',
                  border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }
 
  // --- Step 5: Review & Submit ---
  Widget _buildReviewStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _section('Vehicle', [
            _row('Application Type', draft.natureOfApplication),
            _row('Chassis Number', draft.chassisNumber),
            _row('Vehicle Reg. Number', draft.vehicleRegistrationNumber),
          ]),
          _section('Location', [
            _row('Region', draft.regionName),
            _row('District', draft.districtName),
            _row('Station', draft.stationName),
          ]),
          _section('License Details', [
            _row('License Type', draft.licenseTypeName),
            _row('Duration', draft.licenseDurationName),
            _row('Service Type', draft.serviceTypeName),
            _row('Country', draft.registrationCountryName),
            _row('Seating Capacity', draft.seatingCapacity.toString()),
          ]),
          _section('Contact Person', [
            _row('Name',
                '${draft.contactFirstName ?? ''} ${draft.contactMiddleName ?? ''} ${draft.contactLastName ?? ''}'),
            _row('Gender', draft.contactGender),
            _row('Email', draft.contactEmail),
            _row('Phone', draft.contactPhoneNumber),
          ]),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: draft.userDeclaration,
            onChanged: (v) => setState(() => draft.userDeclaration = v ?? false),
            title: const Text(
              'I confirm the information above is correct and accept the terms of this application.',
            ),
          ),
        ],
      ),
    );
  }
 
  // --- Shared helpers ---
  Widget _dropdown(
    String label,
    bool loading,
    List<LAOption> items,
    LAOption? value,
    ValueChanged<LAOption?> onChanged, {
    bool enabled = true,
  }) {
    return DropdownButtonFormField<LAOption>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: loading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      items: items.map((o) => DropdownMenuItem(value: o, child: Text(o.name))).toList(),
      onChanged: enabled && !loading ? onChanged : null,
    );
  }
 
  Widget _section(String title, List<Widget> rows) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Divider(),
            ...rows,
          ],
        ),
      ),
    );
  }
 
  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value?.isNotEmpty == true ? value! : '—')),
        ],
      ),
    );
  }
}