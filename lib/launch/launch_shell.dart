library atom.launch_shell;

import 'dart:async';

import 'package:atom/node/fs.dart';
import 'package:atom/node/process.dart';

import '../atom.dart';
import '../projects.dart';
import 'launch.dart';

class ShellLaunchType extends LaunchType {
  static void register(LaunchManager manager) =>
      manager.registerLaunchType(new ShellLaunchType());

  ShellLaunchType() : super('shell');

  bool canLaunch(String path) => path.endsWith('.sh') || path.endsWith('.bat');

  List<String> getLaunchablesFor(DartProject project) => [];

  Future<Launch> performLaunch(LaunchManager manager, LaunchConfiguration configuration) {
    String script = configuration.primaryResource;
    String cwd = configuration.cwd;
    List<String> args = configuration.argsAsList;

    String launchName = script;

    // Determine the best cwd.
    if (cwd == null) {
      List<String> paths = atom.project.relativizePath(script);
      if (paths[0] != null) {
        cwd = paths[0];
        launchName = paths[1];
      }
    } else {
      launchName = fs.relativize(cwd, launchName);
    }

    ProcessRunner runner = new ProcessRunner(
      script,
      args: args,
      cwd: cwd);

    String description = args == null ? launchName : '${launchName} ${args.join(' ')}';
    Launch launch = new Launch(manager, this, configuration, launchName,
      killHandler: () => runner.kill(),
      cwd: cwd,
      title: description
    );
    manager.addLaunch(launch);

    runner.execStreaming();
    runner.onStdout.listen((str) => launch.pipeStdio(str));
    runner.onStderr.listen((str) => launch.pipeStdio(str, error: true));
    runner.onExit.then((code) => launch.launchTerminated(code));

    return new Future.value(launch);
  }

  String getDefaultConfigText() {
    return '''
# Additional args for the application.
args:
''';
  }
}
