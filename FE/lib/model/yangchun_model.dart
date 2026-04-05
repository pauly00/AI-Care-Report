class YangchunResultItem {
  final int id;
  final String sttFileName;
  final String status;

  YangchunResultItem({
    required this.id,
    required this.sttFileName,
    required this.status,
  });

  factory YangchunResultItem.fromJson(Map<String, dynamic> json) {
    return YangchunResultItem(
      id: json['id'] ?? 0,
      sttFileName: json['stt_file_name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class YangchunAbstractItem {
  final String subject;
  final String abstract;
  final String detail;

  YangchunAbstractItem({
    required this.subject,
    required this.abstract,
    required this.detail,
  });

  factory YangchunAbstractItem.fromJson(Map<String, dynamic> json) {
    return YangchunAbstractItem(
      subject: json['subject'] ?? '',
      abstract: json['abstract'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}

class YangchunAbstractResponse {
  final int reportId;
  final List<YangchunAbstractItem> items;

  YangchunAbstractResponse({
    required this.reportId,
    required this.items,
  });

  factory YangchunAbstractResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return YangchunAbstractResponse(
      reportId: json['reportid'] ?? json['id'] ?? 0,
      items: rawItems.map((e) => YangchunAbstractItem.fromJson(e)).toList(),
    );
  }
}
