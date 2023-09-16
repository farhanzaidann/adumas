import 'dart:convert';

import 'package:adumas/widgets/my_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

void httpErrorHandler({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;

    default:
      showSnackBar(context, response.body);
  }
}
