package Ytkit::Test::SHOW_WARNINGS;

$WARNING = [
          [
            'Warning',
            1287,
            'SQL_CALC_FOUND_ROWS is deprecated and will be removed in a future release. Consider using two separate queries instead.'
          ],
          [
            'Warning',
            1287,
            'Setting user variables within expressions is deprecated and will be removed in a future release. Consider alternatives: \'SET variable=expression, ...\', or \'SELECT expression(s) INTO variables(s)\'.'
          ],
          [
            'Warning',
            1292,
            'Truncated incorrect DOUBLE value: \'one\''
          ],
          [
            'Warning',
            1292,
            'Truncated incorrect DOUBLE value: \'two\''
          ],
          [
            'Warning',
            1292,
            'Truncated incorrect DOUBLE value: \'three\''
          ],
          [
            'Warning',
            1292,
            'Truncated incorrect DOUBLE value: \'four\''
          ],
          [
            'Warning',
            1292,
            'Truncated incorrect DOUBLE value: \'five\''
          ]
        ];

return 1;
