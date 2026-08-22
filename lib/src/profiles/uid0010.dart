import 'dart:io';

import 'package:mp3cd/src/model/converter.dart';
import 'package:mp3cd/src/util/arg_builder.dart';
import 'package:mp3cd/src/util/binaries.dart';
import 'package:mp3cd/src/util/video_extensions.dart';
import 'package:path/path.dart';

/// [Uid0010].
class Uid0010 extends Converter {
  /// Creates a new [Uid0010].
  Uid0010({required super.inputFile, required super.outputFile});

  @override
  String get id => 'uid0010';

  @override
  Future<void> audio() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.mp3');

    final argBuilder = ArgBuilder()
      ..single('-nostdin')
      ..single('-n')
      ..pair('-i', inputFile.path)
      ..pair('-f', 'mp3')
      ..pair('-ar:a', 16000)
      ..pair('-ac:a', 1)
      ..pair('-q:a', 8)
      ..single(targetOutputFile.path);

    await ffmpeg(argBuilder.args);
  }

  @override
  Future<void> image() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.$id.jpg');

    const size = '128x160';
    final argBuilder = ArgBuilder()
      ..single(inputFile.path)
      ..pair('-interlace', 'none')
      ..single('-auto-orient')
      ..pair('-colorspace', 'sRGB')
      ..single('-strip')
      ..pair('-rotate', '90>')
      ..pair('-resize', '$size^')
      ..pair('-gravity', 'center')
      ..pair('-extent', size)
      ..single(targetOutputFile.path);

    await imageMagick(argBuilder.args);
  }

  @override
  Future<void> text() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.txt');

    await ebookConvert([inputFile.path, targetOutputFile.path]);
  }

  @override
  Future<void> video() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.$id.amv');

    final argBuilder = ArgBuilder()
      ..single('-nostdin')
      ..single('-n')
      ..pair('-i', inputFile.path);

    const size = '160:128';
    const fpsMax = 25;
    final fps = (await inputFile.getAverageFps() ?? fpsMax)
        .clamp(0, fpsMax)
        .nearestLegalAMVFps();
    final blockSize = 22050 ~/ fps;

    if (await inputFile.hasAudio()) {
      argBuilder
        ..pair('-map', '0:v:0')
        ..pair('-map', '0:a:0');
    } else {
      argBuilder
        ..pair('-f', 'lavfi')
        ..pair('-i', 'anullsrc=channel_layout=mono:sample_rate=22050')
        ..pair('-map', '0:v:0')
        ..pair('-map', '1:a')
        ..single('-shortest');
    }

    argBuilder
      ..pair('-f', 'amv')
      ..pair('-c:v', 'amv')
      ..pair(
        '-filter:v',
        'transpose=cclock:passthrough=landscape,scale=$size:force_original_aspect_ratio=increase:flags=area,crop=$size',
      )
      ..pair('-sws_flags', 'accurate_rnd+full_chroma_int+full_chroma_inp')
      ..pair('-r:v', fps)
      ..pair('-block_size:a', blockSize)
      ..single(targetOutputFile.path);

    await ffmpeg(argBuilder.args);
  }
}
