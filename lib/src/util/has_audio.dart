import 'dart:io';

/// Returns true if there is an audio track.
Future<bool> hasAudio(File inputFile) async {
  final result = await Process.run('ffprobe', [
    '-v',
    'error',
    '-select_streams',
    'a:0',
    '-show_entries',
    'stream=index',
    '-of',
    'csv=p=0',
    inputFile.path,
  ]);

  if (result.exitCode != 0) return false;
  return result.stdout.toString().trim().isNotEmpty;
}
