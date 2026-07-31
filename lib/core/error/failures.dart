import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.message = 'An unexpected error occurred']);

  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet connection']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failure occurred']);
}
