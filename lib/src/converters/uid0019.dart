import 'dart:io';

import 'package:mp3cd/src/model/converter.dart';
import 'package:mp3cd/src/util/get_average_fps.dart';
import 'package:mp3cd/src/util/get_legal_amv_fps.dart';
import 'package:mp3cd/src/util/has_audio.dart';

/// Converter for UID0019.
class Uid0019 extends Converter {
  /// Creates a new [Uid0019].
  Uid0019({
    required super.inputFile,
    required super.outputFile,
  });

  @override
  Future<void> convert() async {
    const size = '320:240';
    final averageFps = await getAverageFps(inputFile) ?? 25;
    final fps = getLegalAmvFps(averageFps.ceil()).clamp(0, 25);

    final audio = await hasAudio(inputFile);
    final mapArgs = audio
        ? [
            '-map',
            '0:v:0',
            '-map',
            '0:a:0',
          ]
        : [
            '-f',
            'lavfi',
            '-i',
            'anullsrc=channel_layout=mono:sample_rate=22050',
            '-map',
            '0:v:0',
            '-map',
            '1:a',
            '-shortest',
          ];

    final args = [
      '-i',
      inputFile.path,
      ...mapArgs,
      '-n',
      '-f',
      'amv',
      '-c:v',
      'amv',
      '-filter:v',
      'transpose=cclock:passthrough=landscape,scale=$size:force_original_aspect_ratio=increase:flags=area:out_range=tv,crop=$size',
      '-sws_flags',
      'accurate_rnd+full_chroma_int+full_chroma_inp',
      '-r:v',
      '$fps',
      '-block_size:a',
      '${22050 / fps}',
      outputFile.path,
    ];

    await Process.run('ffmpeg', args);
  }
}
