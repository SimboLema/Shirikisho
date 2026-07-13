// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';


Application applicationFromJson(String str) => Application.fromJson(json.decode(str));

String applicationToJson(Application data) => json.encode(data.toJson());

class Application {
  Application({
    required this.loanAmount,
    required this.tenure,
    required this.paymentRecurrence,
    required this.loanDuration,
    required this.applicationDte,
    // required this.agent,
    required this.approved,
  });

  int loanAmount;
  int tenure;
  int paymentRecurrence;
  int loanDuration;
  String applicationDte;
  // User? agent;
  int approved;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        loanAmount: json["loan_amount"],
        tenure: json["tenure"],
        paymentRecurrence: json["payment_recurrence_days"],
        loanDuration: json["loan_duration_days"],
        applicationDte: json["application_date"],
        // agent: User.fromJson(json["user"]),
        approved: json["approved"],
      );

  Map<String, dynamic> toJson() => {
        "loan_amount":      loanAmount,
        "tenure":           tenure,
        "payment_recurrence_days": paymentRecurrence,
        "loan_duration_days": loanDuration,
        "application_date":   applicationDte,
        // "agent": agent?.toJson(),
        "approved": approved,
      };
}
