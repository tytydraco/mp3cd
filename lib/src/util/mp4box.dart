import 'dart:io';

/// Perform in-place Mp4Box.
Future<void> mp4Box(File inputFile) async {
  await Process.run('MP4Box', [
    '-add',
    inputFile.path,
    '-new',
    '${inputFile.path}.box',
  ]);
  File('${inputFile.path}.box').renameSync(inputFile.path);
}
