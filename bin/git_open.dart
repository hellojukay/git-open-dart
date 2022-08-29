import 'dart:io';

import 'package:git_open/git_open.dart' as git_open;

const timeout = Duration(milliseconds: 650);

Future<void> main(List<String> arguments) async {
  try {
    String remote = await git_open.getRemote();
    open(remote);
  } catch (e) {
    print("无法打开仓库 $e");
  }
}

void open(String link) async {
  if (Platform.isWindows) {
    var cmd = await Process.start("cmd.exe", <String>[]);
    cmd.stdin.write("start $link\n");
    cmd.stdin.flush();
    sleep(timeout);
    cmd.kill();
    return;
  }
  if (Platform.isMacOS) {
    var cmd = await Process.start("open", <String>[link]);
    sleep(timeout);
    cmd.kill();
  } else {
    var cmd = await Process.start("xdg-open", <String>[link]);
    sleep(timeout);
    cmd.kill();
  }
}
