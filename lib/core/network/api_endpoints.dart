class ApiEndpoints {
  static const baseUrl = "http://192.168.1.8:4000";

  // AUTH
  static const login = "/auth/login";
  static const signup = "/auth/signup";
  static const me = "/auth/me";

  // PARTNER
  static const partnerSignup = "/partner/signup";
  static const partnerMe = "/partner/me";

  // ✅ ADD THESE
  static const partnerPending = "/partner/pending";

  static String approvePartner(String partnerId) =>
      "/partner/$partnerId/approve";

  static String rejectPartner(String partnerId) => "/partner/$partnerId/reject";

  // JOBS
  static const String jobs = "/jobs";
  static const String uploadJobsCsv = "/jobs/upload-csv";
}
