use strict;
use warnings;

use Test::More;
use Test::Warn;
use SQL::Abstract::Tree;

my $sqlat = SQL::Abstract::Tree->new;
is_deeply($sqlat->parse("SELECT a, b.*, * FROM foo WHERE foo.a =1 and foo.b LIKE 'station'"), [
  [
    "SELECT",
    [
      [
        "-LIST",
        [
          [
            "-LITERAL",
            [
              "a"
            ]
          ],
          [
            "-LITERAL",
            [
              "b.*"
            ]
          ],
          [
            "-LITERAL",
            [
              "*"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-LITERAL",
        [
          "foo"
        ]
      ]
    ]
  ],
  [
    "WHERE",
    [
      [
        "AND",
        [
          [
            "=",
            [
              [
                "-LITERAL",
                [
                  "foo.a"
                ]
              ],
              [
                "-LITERAL",
                [
                  1
                ]
              ]
            ]
          ],
          [
            "LIKE",
            [
              [
                "-LITERAL",
                [
                  "foo.b"
                ]
              ],
              [
                "-LITERAL",
                [
                  "'station'"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
], 'simple statement parsed correctly');

is_deeply($sqlat->parse( "SELECT * FROM (SELECT * FROM foobar) foo WHERE foo.a =1 and foo.b LIKE 'station'"), [
  [
    "SELECT",
    [
      [
        "-LITERAL",
        [
          "*"
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-MISC",
        [
          [
            "-PAREN",
            [
              [
                "SELECT",
                [
                  [
                    "-LITERAL",
                    [
                      "*"
                    ]
                  ]
                ]
              ],
              [
                "FROM",
                [
                  [
                    "-LITERAL",
                    [
                      "foobar"
                    ]
                  ]
                ]
              ]
            ]
          ],
          [
            "-LITERAL",
            [
              "foo"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "WHERE",
    [
      [
        "AND",
        [
          [
            "=",
            [
              [
                "-LITERAL",
                [
                  "foo.a"
                ]
              ],
              [
                "-LITERAL",
                [
                  1
                ]
              ]
            ]
          ],
          [
            "LIKE",
            [
              [
                "-LITERAL",
                [
                  "foo.b"
                ]
              ],
              [
                "-LITERAL",
                [
                  "'station'"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
], 'subquery statement parsed correctly');

is_deeply($sqlat->parse( "SELECT [screen].[id], [screen].[name], [screen].[section_id], [screen].[xtype] FROM [users_roles] [me] JOIN [roles] [role] ON [role].[id] = [me].[role_id] JOIN [roles_permissions] [role_permissions] ON [role_permissions].[role_id] = [role].[id] JOIN [permissions] [permission] ON [permission].[id] = [role_permissions].[permission_id] JOIN [permissionscreens] [permission_screens] ON [permission_screens].[permission_id] = [permission].[id] JOIN [screens] [screen] ON [screen].[id] = [permission_screens].[screen_id] WHERE ( [me].[user_id] = ? ) GROUP BY [screen].[id], [screen].[name], [screen].[section_id], [screen].[xtype]"), [
  [
    "SELECT",
    [
      [
        "-LIST",
        [
          [
            "-LITERAL",
            [
              "[screen].[id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen].[name]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen].[section_id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen].[xtype]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "[users_roles]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[me]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "JOIN",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "[roles]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[role]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "ON",
    [
      [
        "=",
        [
          [
            "-LITERAL",
            [
              "[role].[id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[me].[role_id]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "JOIN",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "[roles_permissions]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[role_permissions]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "ON",
    [
      [
        "=",
        [
          [
            "-LITERAL",
            [
              "[role_permissions].[role_id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[role].[id]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "JOIN",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "[permissions]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[permission]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "ON",
    [
      [
        "=",
        [
          [
            "-LITERAL",
            [
              "[permission].[id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[role_permissions].[permission_id]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "JOIN",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "[permissionscreens]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[permission_screens]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "ON",
    [
      [
        "=",
        [
          [
            "-LITERAL",
            [
              "[permission_screens].[permission_id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[permission].[id]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "JOIN",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "[screens]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "ON",
    [
      [
        "=",
        [
          [
            "-LITERAL",
            [
              "[screen].[id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[permission_screens].[screen_id]"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "WHERE",
    [
      [
        "-PAREN",
        [
          [
            "=",
            [
              [
                "-LITERAL",
                [
                  "[me].[user_id]"
                ]
              ],
              [
                "-PLACEHOLDER",
                [
                  "?"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "GROUP BY",
    [
      [
        "-LIST",
        [
          [
            "-LITERAL",
            [
              "[screen].[id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen].[name]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen].[section_id]"
            ]
          ],
          [
            "-LITERAL",
            [
              "[screen].[xtype]"
            ]
          ]
        ]
      ]
    ]
  ]
], 'real life statement 1 parsed correctly');

is_deeply($sqlat->parse("CASE WHEN FOO() > BAR()"), [
  [
    "-MISC",
    [
      [
        "-LITERAL",
        [
          "CASE"
        ]
      ],
      [
        "-LITERAL",
        [
          "WHEN"
        ]
      ]
    ]
  ],
  [
    ">",
    [
      [
        "FOO",
        [
          [
            "-PAREN",
            []
          ]
        ]
      ],
      [
        "BAR",
        [
          [
            "-PAREN",
            []
          ]
        ]
      ]
    ]
  ]
]);

is_deeply($sqlat->parse("SELECT [me].[id], ROW_NUMBER ( ) OVER (ORDER BY (SELECT 1)) AS [rno__row__index] FROM bar"), [
  [
    "SELECT",
    [
      [
        "-LIST",
        [
          [
            "-LITERAL",
            [
              "[me].[id]"
            ]
          ],
          [
            "AS",
            [
              [
                "ROW_NUMBER() OVER",
                [
                  [
                    "-PAREN",
                    [
                      [
                        "ORDER BY",
                        [
                          [
                            "-PAREN",
                            [
                              [
                                "SELECT",
                                [
                                  [
                                    "-LITERAL",
                                    [
                                      1
                                    ]
                                  ]
                                ]
                              ]
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ],
              [
                "-LITERAL",
                [
                  "[rno__row__index]"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-LITERAL",
        [
          "bar"
        ]
      ]
    ]
  ]
]);


is_deeply($sqlat->parse("SELECT x, y FROM foo WHERE x IN (?, ?, ?, ?)"), [
  [
    "SELECT",
    [
      [
        "-LIST",
        [
          [
            "-LITERAL",
            [
              "x"
            ]
          ],
          [
            "-LITERAL",
            [
              "y"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-LITERAL",
        [
          "foo"
        ]
      ]
    ]
  ],
  [
    "WHERE",
    [
      [
        "IN",
        [
          [
            "-LITERAL",
            [
              "x"
            ]
          ],
          [
            "-PAREN",
            [
              [
                "-LIST",
                [
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
], 'Lists parsed correctly');

is_deeply($sqlat->parse('SELECT foo FROM bar ORDER BY x + ? DESC, oomph, y - ? DESC, unf, baz.g / ? ASC, buzz * 0 DESC, foo LIKE ? DESC, ickk ASC'), [
  [
    "SELECT",
    [
      [
        "-LITERAL",
        [
          "foo"
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-LITERAL",
        [
          "bar"
        ]
      ]
    ]
  ],
  [
    "ORDER BY",
    [
      [
        "-LIST",
        [
          [
            "-DESC",
            [
              [
                "-MISC",
                [
                  [
                    "-LITERAL",
                    [
                      "x"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "+"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ]
                ]
              ],
            ]
          ],
          [
            "-LITERAL",
            [
              "oomph"
            ]
          ],
          [
            "-DESC",
            [
              [
                "-MISC",
                [
                  [
                    "-LITERAL",
                    [
                      "y"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "-"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                ]
              ],
            ]
          ],
          [
            "-LITERAL",
            [
              "unf"
            ]
          ],
          [
            "-ASC",
            [
              [
                "-MISC",
                [
                  [
                    "-LITERAL",
                    [
                      "baz.g"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "/"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                ]
              ],
            ]
          ],
          [
            "-DESC",
            [
              [
                "-MISC",
                [
                  [
                    "-LITERAL",
                    [
                      "buzz"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "*"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      0
                    ]
                  ]
                ]
              ]
            ]
          ],
          [
            "-DESC",
            [
              [
                "LIKE",
                [
                  [
                    "-LITERAL",
                    [
                      "foo"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                ],
              ],
            ]
          ],
          [
            "-ASC",
            [
              [
                "-LITERAL",
                [
                  "ickk"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
], 'Crazy ORDER BY parsed correctly');

is_deeply( $sqlat->parse("META SELECT * * FROM (SELECT *, FROM foobar baz buzz) foo bar WHERE NOT NOT NOT EXISTS (SELECT 'cr,ap') AND foo.a = ? STUFF moar(stuff) and not (foo.b LIKE 'station') and x = y and z in ((1, 2)) and a = b and GROUP BY , ORDER BY x x1 x2 y asc, max(y) desc x z desc"), [
  [
    "-LITERAL",
    [
      "META"
    ]
  ],
  [
    "SELECT",
    [
      [
        "-MISC",
        [
          [
            "-LITERAL",
            [
              "*"
            ]
          ],
          [
            "-LITERAL",
            [
              "*"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "FROM",
    [
      [
        "-MISC",
        [
          [
            "-PAREN",
            [
              [
                "SELECT",
                [
                  [
                    "-LIST",
                    [
                      [
                        "-LITERAL",
                        [
                          "*"
                        ]
                      ],
                      []
                    ]
                  ]
                ]
              ],
              [
                "FROM",
                [
                  [
                    "-MISC",
                    [
                      [
                        "-LITERAL",
                        [
                          "foobar"
                        ]
                      ],
                      [
                        "-LITERAL",
                        [
                          "baz"
                        ]
                      ],
                      [
                        "-LITERAL",
                        [
                          "buzz"
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ],
          [
            "-LITERAL",
            [
              "foo"
            ]
          ],
          [
            "-LITERAL",
            [
              "bar"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "WHERE",
    [
      [
        "AND",
        [
          [
            "NOT",
            []
          ],
          [
            "NOT",
            []
          ],
          [
            "NOT EXISTS",
            [
              [
                "-PAREN",
                [
                  [
                    "SELECT",
                    [
                      [
                        "-LIST",
                        [
                          [
                            "-LITERAL",
                            [
                              "'cr"
                            ]
                          ],
                          [
                            "-LITERAL",
                            [
                              "ap'"
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ],
          [
            "-MISC",
            [
              [
                "=",
                [
                  [
                    "-LITERAL",
                    [
                      "foo.a"
                    ]
                  ],
                  [
                    "-PLACEHOLDER",
                    [
                      "?"
                    ]
                  ],
                ],
              ],
              [
                "-LITERAL",
                [
                  "STUFF"
                ]
              ],
            ],
          ],
          [
            'moar',
            [
              [
                '-PAREN',
                [
                  [
                    '-LITERAL',
                    [
                      'stuff'
                    ]
                 ]
                ]
              ]
            ]
          ],
          [
            "NOT",
            [
              [
                "-PAREN",
                [
                  [
                    "LIKE",
                    [
                      [
                        "-LITERAL",
                        [
                          "foo.b"
                        ]
                      ],
                      [
                        "-LITERAL",
                        [
                          "'station'"
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ],
          [
            "=",
            [
              [
                "-LITERAL",
                [
                  "x"
                ]
              ],
              [
                "-LITERAL",
                [
                  "y"
                ]
              ]
            ]
          ],
          [
            'IN',
            [
              [
                '-LITERAL',
                [
                  'z',
                ],
              ],
              [
                '-PAREN',
                [
                  [
                    '-PAREN',
                    [
                      [
                        '-LIST',
                        [
                          [
                            '-LITERAL',
                            [
                              '1'
                            ]
                          ],
                          [
                            '-LITERAL',
                            [
                              '2'
                            ]
                          ],
                        ],
                      ],
                    ],
                  ],
                ],
              ],
            ],
          ],
          [
            "=",
            [
              [
                "-LITERAL",
                [
                  "a"
                ]
              ],
              [
                "-LITERAL",
                [
                  "b"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "GROUP BY",
    [
      [
        "-LIST",
        [
          [],
          []
        ]
      ]
    ]
  ],
  [
    "ORDER BY",
    [
      [
        "-LIST",
        [
          [
            "-ASC",
            [
              [
                "-MISC",
                [
                  [
                    "-LITERAL",
                    [
                      "x"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "x1"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "x2"
                    ]
                  ],
                  [
                    "-LITERAL",
                    [
                      "y"
                    ]
                  ]
                ]
              ],
            ],
          ],
          [
                "-DESC",
                [
                  [
                    "-MISC",
                    [
                      [
                        "-DESC",
                        [
                          [
                            "max",
                            [
                              [
                                "-PAREN",
                                [
                                  [
                                    "-LITERAL",
                                    [
                                      "y"
                                    ]
                                  ]
                                ]
                              ]
                            ],
                          ]
                        ]
                      ],
                      [
                        "-LITERAL",
                        [
                          "x"
                        ]
                      ],
                  [
                    "-LITERAL",
                    [
                      "z"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
], 'Deliberately malformed SQL parsed "correctly"');


# test for recursion warnings on huge selectors
my @lst = ('AA' .. 'zz');
#@lst = ('AAA' .. 'zzz'); # if you really want to wait a while
warnings_are {
  my $sql = sprintf 'SELECT %s FROM foo', join (', ',  (map { qq|( "$_" )| } @lst), (map { qq|"$_"| } @lst), (map { qq|"$_", ( "$_" )| } @lst) );
  my $tree = $sqlat->parse($sql);

  is_deeply( $tree, [
    [
      "SELECT",
      [
        [
          "-LIST",
          [
            (map { [ -PAREN => [ [ -LITERAL => [ qq|"$_"| ] ] ] ] } @lst),
            (map { [ -LITERAL => [ qq|"$_"| ] ] } @lst),
            (map { [ -LITERAL => [ qq|"$_"| ] ], [ -PAREN => [ [ -LITERAL => [ qq|"$_"| ] ] ] ] } @lst),
          ]
        ]
      ]
    ],
    [
      "FROM",
      [
        [
          "-LITERAL",
          [
            "foo"
          ]
        ]
      ]
    ]
  ], 'long list parsed correctly');

  is( $sqlat->unparse($tree), $sql, 'roundtrip ok');
} [], 'no recursion warnings on insane SQL';

done_testing;
