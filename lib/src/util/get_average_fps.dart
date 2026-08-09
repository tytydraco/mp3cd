import 'dart:io';

/// Return the average FPS as a double.
Future<double?> getAverageFps(File inputFile) async {
  final result = await Process.run('ffprobe', [
    '-v',
    'error',
    '-select_streams',
    'v:0',
    '-show_entries',
    'stream=avg_frame_rate',
    '-of',
    'csv=p=0',
    inputFile.path,
  ]);

  if (result.exitCode != 0) return null;

  final output = result.stdout.toString();

  final parts = output.split('/');
  if (parts.length == 1) return double.parse(output);

  final numerator = double.parse(parts[0]);
  final denominator = double.parse(parts[1]);

  return numerator / denominator;
}
