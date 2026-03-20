import 'dart:html' as html;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../../../core/network/api_client.dart';

class CandidateUploadRepository {
  final Dio _dio = ApiClient.instance;

  Future<String> uploadResumes(List<dynamic> files) async {
    try {
      print("========================================");
      print("UPLOAD RESUMES API CALLED");
      print("TOTAL FILES: ${files.length}");

      final formData = FormData();

      int index = 0;

      for (var file in files) {
        print("---- Processing File ${index + 1} ----");
        print("File name: ${file.name}");

        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;

        final bytes = reader.result as Uint8List;

        print("File size (bytes): ${bytes.length}");

        formData.files.add(
          MapEntry(
            "resumes",
            MultipartFile.fromBytes(bytes, filename: file.name),
          ),
        );

        index++;
      }

      print("All files added to FormData");
      print("Sending API request...");

      final response = await _dio.post("/admin/resumes/upload", data: formData);

      print("Response received!");
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      final jobId = response.data["jobId"];

      if (jobId == null) {
        print("ERROR: jobId missing in response");
        throw Exception("jobId not found in response");
      }

      print("JOB ID: $jobId");

      return jobId;
    } on DioException catch (e) {
      print("========================================");
      print("UPLOAD FAILED");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("ERROR: ${e.message}");
      rethrow;
    }
  }
}
