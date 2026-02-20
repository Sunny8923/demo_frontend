import 'candidate_model.dart';

class ApplicationModel {
  //////////////////////////////////////////////////////
  /// Core
  //////////////////////////////////////////////////////

  final String id;

  final DateTime createdAt;
  final DateTime updatedAt;

  //////////////////////////////////////////////////////
  /// Job info
  //////////////////////////////////////////////////////

  final String jobId;
  final String jobTitle;
  final String? jobDescription;
  final String? jobCompanyName;
  final String? jobLocation;

  //////////////////////////////////////////////////////
  /// Candidate
  //////////////////////////////////////////////////////

  final String candidateId;
  final CandidateModel candidate;

  //////////////////////////////////////////////////////
  /// Pipeline
  //////////////////////////////////////////////////////

  final String pipelineStage;
  final String? finalStatus;

  //////////////////////////////////////////////////////
  /// Metadata
  //////////////////////////////////////////////////////

  final String? source;
  final String? notes;
  final String? rejectionReason;

  //////////////////////////////////////////////////////
  /// Partner info (NEW)
  //////////////////////////////////////////////////////

  final String? partnerId;
  final String? partnerOrganisationName;
  final String? partnerOwnerName;

  //////////////////////////////////////////////////////
  /// Direct user info (NEW)
  //////////////////////////////////////////////////////

  final String? appliedByUserId;
  final String? appliedByUserName;

  //////////////////////////////////////////////////////
  /// Pipeline timestamps
  //////////////////////////////////////////////////////

  final DateTime? contactedAt;
  final DateTime? interviewScheduledAt;
  final DateTime? interviewCompletedAt;
  final DateTime? offerSentAt;
  final DateTime? offerAcceptedAt;
  final DateTime? offerRejectedAt;
  final DateTime? hiredAt;
  final DateTime? rejectedAt;

  //////////////////////////////////////////////////////
  /// Constructor
  //////////////////////////////////////////////////////

  const ApplicationModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.jobId,
    required this.jobTitle,
    this.jobDescription,
    this.jobCompanyName,
    this.jobLocation,

    required this.candidateId,
    required this.candidate,

    required this.pipelineStage,
    this.finalStatus,

    this.source,
    this.notes,
    this.rejectionReason,

    this.partnerId,
    this.partnerOrganisationName,
    this.partnerOwnerName,

    this.appliedByUserId,
    this.appliedByUserName,

    this.contactedAt,
    this.interviewScheduledAt,
    this.interviewCompletedAt,
    this.offerSentAt,
    this.offerAcceptedAt,
    this.offerRejectedAt,
    this.hiredAt,
    this.rejectedAt,
  });

  //////////////////////////////////////////////////////
  /// Factory
  //////////////////////////////////////////////////////

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    final job = json['job'] ?? {};
    final candidateJson = json['candidate'] ?? {};

    final partner = json['appliedByPartner'];
    final appliedByUser = json['appliedByUser'];

    return ApplicationModel(
      //////////////////////////////////////////////////////
      /// Core
      //////////////////////////////////////////////////////
      id: json['id'],

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      //////////////////////////////////////////////////////
      /// Job
      //////////////////////////////////////////////////////
      jobId: job['id'] ?? '',
      jobTitle: job['title'] ?? '',
      jobDescription: job['description'],
      jobCompanyName: job['companyName'],
      jobLocation: job['location'],

      //////////////////////////////////////////////////////
      /// Candidate
      //////////////////////////////////////////////////////
      candidateId: candidateJson['id'] ?? '',
      candidate: CandidateModel.fromJson(candidateJson),

      //////////////////////////////////////////////////////
      /// Pipeline
      //////////////////////////////////////////////////////
      pipelineStage: json['pipelineStage'] ?? 'APPLIED',
      finalStatus: json['finalStatus'],

      //////////////////////////////////////////////////////
      /// Metadata
      //////////////////////////////////////////////////////
      source: json['source'],
      notes: json['notes'],
      rejectionReason: json['rejectionReason'],

      //////////////////////////////////////////////////////
      /// Partner info
      //////////////////////////////////////////////////////
      partnerId: partner?['id'],
      partnerOrganisationName: partner?['organisationName'],
      partnerOwnerName: partner?['ownerName'],

      //////////////////////////////////////////////////////
      /// Direct user info
      //////////////////////////////////////////////////////
      appliedByUserId: appliedByUser?['id'],
      appliedByUserName: appliedByUser?['name'],

      //////////////////////////////////////////////////////
      /// Timestamps
      //////////////////////////////////////////////////////
      contactedAt: _parseDate(json['contactedAt']),
      interviewScheduledAt: _parseDate(json['interviewScheduledAt']),
      interviewCompletedAt: _parseDate(json['interviewCompletedAt']),
      offerSentAt: _parseDate(json['offerSentAt']),
      offerAcceptedAt: _parseDate(json['offerAcceptedAt']),
      offerRejectedAt: _parseDate(json['offerRejectedAt']),
      hiredAt: _parseDate(json['hiredAt']),
      rejectedAt: _parseDate(json['rejectedAt']),
    );
  }

  //////////////////////////////////////////////////////
  /// Helpers
  //////////////////////////////////////////////////////

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  //////////////////////////////////////////////////////
  /// Convenience getters
  //////////////////////////////////////////////////////

  String get displayStatus => finalStatus ?? pipelineStage;

  bool get isHired => finalStatus == "HIRED";

  bool get isRejected => finalStatus == "REJECTED";

  bool get isInProgress => finalStatus == null && pipelineStage != "REJECTED";

  //////////////////////////////////////////////////////
  /// Convenience getters for UI
  //////////////////////////////////////////////////////

  bool get isPartnerApplication => partnerId != null;

  String get displaySourceName {
    if (partnerOrganisationName != null) {
      return partnerOrganisationName!;
    }

    if (appliedByUserName != null) {
      return appliedByUserName!;
    }

    return "Unknown";
  }
}
