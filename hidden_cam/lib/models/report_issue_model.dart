import 'dart:convert';

enum ReportNoticeType {
  suspiciousDevice,
  unexpectedCamera,
  unusualObject,
  other,
}

extension ReportNoticeTypeExt on ReportNoticeType {
  String get label {
    switch (this) {
      case ReportNoticeType.suspiciousDevice:
        return 'Suspicious device';
      case ReportNoticeType.unexpectedCamera:
        return 'Unexpected camera';
      case ReportNoticeType.unusualObject:
        return 'Unusual object';
      case ReportNoticeType.other:
        return 'Other privacy concern';
    }
  }

  String get description {
    switch (this) {
      case ReportNoticeType.suspiciousDevice:
        return 'Unfamiliar signal or hidden beacon';
      case ReportNoticeType.unexpectedCamera:
        return 'Pinhole lens, altered smoke detector';
      case ReportNoticeType.unusualObject:
        return 'Wall charger, decorative anomaly';
      case ReportNoticeType.other:
        return 'General physical privacy observation';
    }
  }
}

class ReportIssueModel {
  final String id;
  final ReportNoticeType noticeType;
  final String location;
  final String notes;
  final bool hasPhotoAttached;
  final DateTime timestamp;
  final bool consentGiven;

  const ReportIssueModel({
    required this.id,
    required this.noticeType,
    required this.location,
    required this.notes,
    required this.hasPhotoAttached,
    required this.timestamp,
    required this.consentGiven,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noticeType': noticeType.name,
      'location': location,
      'notes': notes,
      'hasPhotoAttached': hasPhotoAttached,
      'timestamp': timestamp.toIso8601String(),
      'consentGiven': consentGiven,
    };
  }

  factory ReportIssueModel.fromMap(Map<String, dynamic> map) {
    return ReportIssueModel(
      id: map['id'] ?? '',
      noticeType: ReportNoticeType.values.firstWhere(
        (e) => e.name == map['noticeType'],
        orElse: () => ReportNoticeType.suspiciousDevice,
      ),
      location: map['location'] ?? '',
      notes: map['notes'] ?? '',
      hasPhotoAttached: map['hasPhotoAttached'] ?? false,
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      consentGiven: map['consentGiven'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportIssueModel.fromJson(String source) =>
      ReportIssueModel.fromMap(json.decode(source));
}
