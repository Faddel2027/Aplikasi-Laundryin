/// Base failure class for Laundryin error handling.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Terjadi kesalahan pada server. Coba lagi nanti.',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Koneksi internet bermasalah. Periksa jaringanmu.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Autentikasi gagal. Silakan masuk kembali.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
