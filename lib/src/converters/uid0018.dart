import 'dart:io';

import 'package:mp3cd/src/model/converter.dart';
import 'package:mp3cd/src/util/mp4box.dart';
import 'package:mp3cd/src/util/util.dart';

/// Converter for UID0018.
class Uid0018 extends Converter {
  /// Creates a new [Uid0018].
  Uid0018({
    required super.inputFile,
    required super.outputFile,
  });

  @override
  Future<void> convert() async {
    const size = '320:240';
    final averageFps = await getAverageFps(inputFile);
    final fps = averageFps?.clamp(0, 25) ?? 25;
    await Process.run('ffmpeg', [
      '-i',
      inputFile.path,
      '-n',
      '-f',
      'mp4',
      '-map',
      '0:v:0',
      '-map',
      '0:a:0?',
      '-c:v',
      'libxvid',
      '-filter:v',
      'transpose=cclock:passthrough=landscape,scale=$size:force_original_aspect_ratio=increase:flags=area:out_range=tv,crop=$size',
      '-sws_flags',
      'accurate_rnd+full_chroma_int+full_chroma_inp',
      '-pix_fmt:v',
      'yuv420p',
      '-q:v',
      '6',
      '-r:v',
      '$fps',
      '-c:a',
      'aac',
      '-ar:a',
      '16000',
      '-ac:a',
      '1',
      outputFile.path,
    ]);
    await mp4Box(outputFile);
  }
}
