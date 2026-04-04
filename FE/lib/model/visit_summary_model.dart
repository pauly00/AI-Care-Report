class VisitSummary {
  final String subject;
  String abstract;
  String detail;

  VisitSummary({
    required this.subject,
    required this.abstract,
    required this.detail,
  });

  factory VisitSummary.fromJson(Map<String, dynamic> json) {
    return VisitSummary(
      subject: json['subject'] ?? '',
      abstract: json['abstract'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}

class VisitSummaryResponse {
  final int reportId;
  final List<VisitSummary> items;

  VisitSummaryResponse({
    required this.reportId,
    required this.items,
  });

  factory VisitSummaryResponse.fromJson(Map<String, dynamic> json) {
    return VisitSummaryResponse(
      reportId: json['reportid'],
      items: (json['items'] as List<dynamic>)
          .map((e) => VisitSummary.fromJson(e))
          .toList(),
    );
  }
}
