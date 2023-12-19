import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:pharmacy_online/core/error/failure.dart';

abstract class UseCase<P, R> {
  set ref(Ref ref) {}

  Logger? _logger;
  Logger get logger {
    if (_logger != null) {
      return _logger!;
    }
    _logger = Logger(runtimeType.toString());
    return _logger!;
  }

  @protected
  Future<R> exec(P request);

  Future<Result<R, Failure>> execute(P request) async {
    try {
      final result = await exec(request);
      return Success(result);
    } on FirebaseException catch (e) {
      return Error(
        Failure(
          message: e.message ?? '',
        ),
      );
    }
  }
}
