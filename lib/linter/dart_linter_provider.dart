part of linter;

/// This only class exists to provide linting information to atomlinter/linter.
class DartLinterProvider extends LinterProvider {
  // TODO: Options are 'file' and 'project' scope, and lintOnFly true or false.
  DartLinterProvider()
      : super(grammarScopes: ['source.dart'], scope: 'project');

  void register() =>
      LinterProvider.registerLinterProvider('provideLinter', this);

  /// This is a no-op.
  Future<List<LintMessage>> lint(TextEditor editor) {
    return new Future.value([]);
  }
}
