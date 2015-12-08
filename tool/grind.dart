import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
@Depends(test,testVisual)
build() {
}

@Task()
@Depends(analyze)
test() {
    new TestRunner().testAsync(files: "test/unit");
    // new TestRunner().testAsync(files: "test/integration");

    // Alle test mit @TestOn("content-shell") im header
    // new TestRunner().test(files: "test/unit",platformSelector: "content-shell");
    // new TestRunner().test(files: "test/integration",platformSelector: "content-shell");
}

@Task()
@Depends(analyze)
testVisual() {
    Dart.run("bin/dasic.dart",arguments: [ "test/visual/hello.das" ]);
    Dart.run("bin/dasic.dart",arguments: [ "test/visual/hellos.das" ]);
    Dart.run("bin/dasic.dart",arguments: [ "test/visual/mandel.das" ]);
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/cmdline.dart",
        "lib/dasic.dart",
        "bin/dasic.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    Analyzer.analyze("test");
}

@Task()
clean() => defaultClean();
