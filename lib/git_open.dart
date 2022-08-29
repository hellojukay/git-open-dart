import 'dart:io';

Future<String> getRemote() async {
  ProcessResult result = await Process.run('git', ['remote', '-v']);
  String stdout = result.stdout;
  String url = '';
  if (result.exitCode != 0) {
    throw Exception('获取 remote 失败了 ${result.stderr}');
  }
  RegExp regExp = RegExp(r'origin\s(http.*?)\s');
  var allMatchs = regExp.allMatches(stdout);
  if (allMatchs.isNotEmpty) {
    url = allMatchs.elementAt(0).group(1).toString();
  } else {
    throw Exception('获取 remote 失败了 $stdout');
  }
  // 1. 先把 :// 转成 ^^^
  // 2. 然后替换 : 为 /
  // 3. 最后把 ^^^ 转回 ://
  const temp = "^^^";
  url = url.replaceAll(RegExp(r'.git$'), '');
  url = url.replaceAll("://", temp);
  url = url.replaceAll(":", "/");
  url = url.replaceAll(temp, "://");
  return url;
}
