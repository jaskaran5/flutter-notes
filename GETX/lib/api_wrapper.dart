import 'dart:developer';

import 'package:get_x/employe_model.dart';
import 'package:http/http.dart' as http;

class ApiWrapper {
  Future<EmployeeModel?> getData() async {
    var data = await http
        .get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees'));
    if (data.statusCode == 200) {
      final data1 = employeeModelFromJson(data.body);
      return data1;
    } else {
      log('error');
      return null;
    }
  }
}
