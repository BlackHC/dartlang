library atom.flutter.mojo_launch;

import '../launch/launch.dart';
import '../projects.dart';
import 'flutter_launch.dart';

class MojoLaunchType extends FlutterLaunchType {
  static void register(LaunchManager manager) =>
      manager.registerLaunchType(new MojoLaunchType());

  MojoLaunchType() : super('mojo');

  String get flutterRunCommand => 'run_mojo';

  // We don't want to advertise the mojo launch configuration as much as the flutter one.
  List<String> getLaunchablesFor(DartProject project) => <String>[];

  String getDefaultConfigText() {
    return 'checked: true\n# args:\n#  - --mojo-path=path/to/mojo';
  }
}
