part of dasic.test;

testUtils() {
    final Logger _logger = new Logger("test.Utils");

    group('Utils', () {
        setUp(() { });
        
        test('> isLetterOrDigit', () {
            expect(Utils.isLetterOrDigit("a"),isTrue);
            expect(Utils.isLetterOrDigit("Z"),isTrue);
            expect(Utils.isLetterOrDigit("1"),isTrue);
            expect(Utils.isLetterOrDigit("9"),isTrue);

            expect(Utils.isLetterOrDigit("."),isFalse);
            expect(Utils.isLetterOrDigit("#"),isFalse);
            expect(Utils.isLetterOrDigit("-"),isFalse);

            bool foundError = false;
            try {
                Utils.isLetterOrDigit("");

            } on ArgumentError catch(e) {
                foundError = true;
            }
            expect(foundError,isTrue);

        }); // end of 'isLetterOrDigit' test


        test('> isDigit', () {
            expect(Utils.isDigit("1"),isTrue);
            expect(Utils.isDigit("9"),isTrue);

            expect(Utils.isDigit("."),isFalse);
            expect(Utils.isDigit("a"),isFalse);

            bool foundError = false;
            try {
                Utils.isDigit(null);

            } on ArgumentError catch(e) {
                foundError = true;
            }
            expect(foundError,isTrue);
        }); // end of 'isDigit' test

        test('> isLetter', () {
            expect(Utils.isLetter("a"),isTrue);
            expect(Utils.isLetter("Z"),isTrue);

            expect(Utils.isLetter("1"),isFalse);
            expect(Utils.isLetter("9"),isFalse);
            expect(Utils.isLetter("."),isFalse);
            expect(Utils.isLetter("#"),isFalse);
            expect(Utils.isLetter("-"),isFalse);
        }); // end of 'isLetter' test


    });
    // end 'Utils' group
}

// - Helper --------------------------------------------------------------------------------------
