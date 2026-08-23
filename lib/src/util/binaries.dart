import 'dart:convert';
import 'dart:io';

/// Run a process and return the exit code. Write to [stdout] and [stderr].
Future<ProcessResult> run(
  String executable,
  List<String> args,
) async {
  final process = await Process.start(executable, args);

  final stdoutBuffer = StringBuffer();
  final stderrBuffer = StringBuffer();

  final stdoutFuture = process.stdout.transform(utf8.decoder).listen((data) {
    stdout.write(data);
    stdoutBuffer.write(data);
  }).asFuture<dynamic>();

  final stderrFuture = process.stderr.transform(utf8.decoder).listen((data) {
    stderr.write(data);
    stderrBuffer.write(data);
  }).asFuture<dynamic>();

  final exitCode = await process.exitCode;

  await Future.wait([stdoutFuture, stderrFuture]);

  return ProcessResult(
    process.pid,
    exitCode,
    stdoutBuffer.toString(),
    stderrBuffer.toString(),
  );
}

/// FFmpeg.
Future<ProcessResult> ffmpeg(List<String> args) => run('ffmpeg', args);

/// FFprobe.
Future<ProcessResult> ffprobe(List<String> args) => run('ffprobe', args);

/// FFmpeg with YP3 x264 patch.
Future<ProcessResult> ffmpegYp3Patch(List<String> args) =>
    run('ffmpeg-yp3-patch', args);

/// Image Magick convert.
Future<ProcessResult> imageMagick(List<String> args) => run('convert', args);

/// Calibre ebook-convert.
Future<ProcessResult> ebookConvert(List<String> args) =>
    run('ebook-convert', args);

/// MP4Box.
Future<ProcessResult> mp4Box(List<String> args) => run('MP4Box', args);
