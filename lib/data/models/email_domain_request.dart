// lib/data/models/email_domain_request.dart
class EmailDomainRequest {
  final String emailDomain;

  EmailDomainRequest({required this.emailDomain});

  Map<String, dynamic> toJson() {
    return {
      'emailDomain': emailDomain,
    };
  }
}