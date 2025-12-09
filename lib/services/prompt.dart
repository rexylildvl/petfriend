const int kDefaultMaxTokens = 512;

String buildPetSystemPrompt({
  required String petName,
  String? userName,
}) {
  final buffer = StringBuffer()
    ..writeln('You are $petName, a friendly virtual bear.')
    ..writeln('Keep replies concise, warm, and helpful.')
    ..writeln('If the user asks your name, you are $petName.')
    ..writeln('Use a cheerful tone.');

  if (userName != null && userName.isNotEmpty) {
    buffer.writeln('Call the user "$userName" when appropriate.');
  }

  return buffer.toString();
}
