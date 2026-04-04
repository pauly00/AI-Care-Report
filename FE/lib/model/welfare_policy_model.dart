class WelfarePolicy {
  final int id;
  final String policyName;
  final String shortDescription;
  final List<String> detailedConditions;
  final String link;
  int checkStatus;

  WelfarePolicy({
    required this.id,
    required this.policyName,
    required this.shortDescription,
    required this.detailedConditions,
    required this.link,
    required this.checkStatus,
  });

  factory WelfarePolicy.fromJson(Map<String, dynamic> json) {
    return WelfarePolicy(
      id: json['id'] ?? 0,
      policyName: json['policy_name'] as String,
      shortDescription: json['short_description'] as String,
      detailedConditions: List<String>.from(json['detailed_conditions']),
      link: json['link'] as String,
      checkStatus: json['checkStatus'] ?? 1,
    );
  }

  static List<WelfarePolicy> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => WelfarePolicy.fromJson(e)).toList();
  }
}
