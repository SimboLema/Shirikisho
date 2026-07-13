/// Carries the in-progress license application across all wizard screens.
/// Pass the SAME instance forward via each Navigator.push constructor —
/// each screen mutates it directly, the last screen submits it.
class LicenseApplicationDraft {
  // Step 1: Vehicle & Application Type
  String? natureOfApplication; // "NEW" | "RENEW"
  String? chassisNumber;
  String? vehicleRegistrationNumber;
  String? tiraCoverNoteNumber;
  String? virNumber;

  // Step 2: Location
  String? regionUid;
  String? regionName; // for display on review screen
  String? districtUid;
  String? districtName;
  String? stationUid;
  String? stationName;

  // Step 3: License Details
  String? licenseTypeUid;
  String? licenseTypeName;
  String? licenseDurationUid;
  String? licenseDurationName;
  String? serviceTypeUid;
  String? serviceTypeName;
  String? registrationCountryUid;
  String? registrationCountryName;
  int seatingCapacity = 1;

  // Step 4: Contact Person
  String? contactFirstName;
  String? contactMiddleName;
  String? contactLastName;
  String? contactGender; // "MALE" | "FEMALE"
  String? contactEmail;
  String? contactPhoneNumber;
  String? contactDistrictUid; // usually same as districtUid, kept separate per API shape

  // Step 5: Declaration
  bool userDeclaration = false;

  bool get vehicleStepComplete =>
      natureOfApplication != null &&
      (chassisNumber?.isNotEmpty ?? false) &&
      (vehicleRegistrationNumber?.isNotEmpty ?? false);

  bool get locationStepComplete =>
      regionUid != null && districtUid != null && stationUid != null;

  bool get licenseStepComplete =>
      licenseTypeUid != null &&
      licenseDurationUid != null &&
      serviceTypeUid != null &&
      registrationCountryUid != null &&
      seatingCapacity > 0;

  bool get contactStepComplete =>
      (contactFirstName?.isNotEmpty ?? false) &&
      (contactLastName?.isNotEmpty ?? false) &&
      contactGender != null &&
      (contactEmail?.isNotEmpty ?? false) &&
      (contactPhoneNumber?.isNotEmpty ?? false);

  /// Builds the exact JSON body the Laravel /latra/applications endpoint expects.
  Map<String, dynamic> toApiPayload() {
    return {
      "applicationBatchUid": null,
      "branchUid": null,
      "chassisNumber": chassisNumber,
      "contactPersonDetailDto": {
        "districtUid": contactDistrictUid ?? districtUid,
        "email": contactEmail,
        "firstName": contactFirstName,
        "gender": contactGender,
        "lastName": contactLastName,
        "middleName": contactMiddleName,
        "phoneNumber": contactPhoneNumber,
      },
      "districtUid": districtUid,
      "licenseDetailDto": {
        "licenseDurationUid": licenseDurationUid,
        "registrationCountryUid": registrationCountryUid,
        "seatingCapacity": seatingCapacity,
        "serviceTypeUid": serviceTypeUid,
        "stationUid": stationUid,
      },
      "natureOfApplication": natureOfApplication,
      "tiraCoverNoteNumber": (tiraCoverNoteNumber == null || tiraCoverNoteNumber!.isEmpty)
          ? "NULL"
          : tiraCoverNoteNumber,
      "userDeclaration": userDeclaration,
      "vehicleRegistrationNumber": vehicleRegistrationNumber,
      "virNumber": (virNumber == null || virNumber!.isEmpty) ? "NULL" : virNumber,
    };
  }
}