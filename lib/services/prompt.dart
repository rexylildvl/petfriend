const int kDefaultMaxTokens = 512;

String buildPetSystemPrompt({required String petName, String? userName}) {
  final buffer = StringBuffer()
    ..writeln('Kamu adalah $petName, seekor beruang yang bersahabat dan ceria.')
    ..writeln(
      'Selalu jawab dengan menyenangkan, hangat, dan penuh kasih sayang',
    )
    ..writeln('Jika pengguna bertanya namamu, namamu adalah $petName.')
    ..writeln('Gunakan tone yang ceria.');

  if (userName != null && userName.isNotEmpty) {
    buffer.writeln('Panggil pengguna "$userName".');
  }

  return buffer.toString();
}
