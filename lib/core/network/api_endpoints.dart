class ApiEndpoints {
  static const baseUrl = "https://demo-backend-4yf0.onrender.com";

  ////////////////////////////////////////////////////////////
  /// AUTH
  ////////////////////////////////////////////////////////////

  static const String login = "/auth/login";
  static const String signup = "/auth/signup";
  static const String me = "/auth/me";

  ////////////////////////////////////////////////////////////
  /// PARTNER (FIXED)
  ////////////////////////////////////////////////////////////

  static const String partnerSignup = "/partner/signup";

  static const String partnerPending = "/partner/pending";

  static String approvePartner(String partnerId) =>
      "/partner/$partnerId/approve";

  static String rejectPartner(String partnerId) => "/partner/$partnerId/reject";

  static const String partnerMe = "/partner/me";

  ////////////////////////////////////////////////////////////
  /// JOBS
  ////////////////////////////////////////////////////////////

  static const String jobs = "/jobs";

  static const String uploadJobsCsv = "/jobs/upload-csv";
}
