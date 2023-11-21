import 'dart:developer';
import 'dart:io';

import 'package:onestore/config/host_con.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageUploadService {
  static Future uploadImage(
      Map<String, String> body, String filePath, File file) async {
    String addimageUrl = hostname + 'uploadsingle_master';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl));
    String fileName = file.path.split('/').last;
    request.fields.addAll(body);
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    var response = await request.send();
    if (response.statusCode == 201) {
      log("Response true:");
      return true;
    } else if (response.statusCode == 200) {
      log("File upload completely");
      final res = await http.Response.fromStream(response);
      log(res.body);
      log("body: " + res.body);
      return true;
    } else {
      log("Response fail:");
      return false;
      // await http.MultipartFile.fromPath(field, filePath)
    }
  }

  static Future updateProfileImage(
      Map<String, String> body, String filePath, File file) async {
    String addimageUrl = hostname + 'uploadsingle_master_update';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl));
    String fileName = file.path.split('/').last;
    request.fields.addAll(body);
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    var response = await request.send();
    if (response.statusCode == 201) {
      log("Response true:");
      return true;
    } else if (response.statusCode == 200) {
      log("File upload completely");
      final res = await http.Response.fromStream(response);
      log(res.body);
      log("body: " + res.body);
      return true;
    } else {
      log("Response fail:");
      return false;
      // await http.MultipartFile.fromPath(field, filePath)
    }
  }
}
