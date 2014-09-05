use warnings;
use strict;

use Test::More;
use Test::Exception;
use Storable 'nfreeze';

use SQL::Abstract qw(is_plain_value is_literal_value);

{
  package # hideee
    SQLATest::SillyInt;

  use overload
    # *DELIBERATELY* unspecified
    #fallback => 1,
    '0+' => sub { ${$_[0]} },
  ;

  package # hideee
    SQLATest::SillyInt::Subclass;

  our @ISA = 'SQLATest::SillyInt';
}

{
  package # hideee
    SQLATest::SillierInt;

  use overload
    fallback => 0,
  ;

  package # hideee
    SQLATest::SillierInt::Subclass;

  use overload
    '0+' => sub { ${$_[0]} },
    '+' => sub { ${$_[0]} + $_[1] },
  ;

  our @ISA = 'SQLATest::SillierInt';
}

{
  package # hidee
    SQLATest::ReasonableInt;

  use overload
    '0+' => sub { ${$_[0]} },
    '++' => sub { $_[0] = ${$_[0]} + 1 },
    '--' => sub { $_[0] = ${$_[0]} - 1 },
    fallback => 1,
  ;
}

# make sure we recognize overloaded stuff properly
lives_ok {
  my $num = bless( \do { my $foo = 69 }, 'SQLATest::SillyInt::Subclass' );

  # is_deeply does not do nummify/stringify cmps properly
  # but we can always compare the ice
  ok(
    ( nfreeze( is_plain_value $num ) eq nfreeze( [ $num ] ) ),
    'parent-fallback-provided stringification detected'
  );
  is("$num", 69, 'test overloaded object stringifies, without specified fallback');
} 'overload testing lives';

{
  my $nummifiable_maybefallback_num = bless( \do { my $foo = 42 }, 'SQLATest::SillierInt::Subclass' );
  lives_ok {
    ok( ( $nummifiable_maybefallback_num + 1) == 43 )
  };

  my $is_pv_res = is_plain_value $nummifiable_maybefallback_num;

  # this perl can recognize inherited fallback
  if ( !! eval { "$nummifiable_maybefallback_num" } ) {
    # we may *not* be able to compare, due to ""-derived-eq fallbacks missing,
    # but we can always compare the ice
    ok (
      ( nfreeze( $is_pv_res ) eq nfreeze( [ $nummifiable_maybefallback_num ] ) ),
      'parent-disabled-fallback stringification matches that of perl'
    );
  }
  else {
    is $is_pv_res, undef, 'parent-disabled-fallback stringification matches that of perl';
  }
}

lives_ok {
  my $num = bless( \do { my $foo = 23 }, 'SQLATest::ReasonableInt' );
  cmp_ok(++$num, '==', 24, 'test overloaded object compares correctly');
  cmp_ok(--$num, 'eq', 23, 'test overloaded object compares correctly');
  is_deeply(
    is_plain_value $num,
    [ 23 ],
    'fallback stringification detected'
  );
  cmp_ok(--$num, 'eq', 22, 'test overloaded object compares correctly');
  cmp_ok(++$num, '==', 23, 'test overloaded object compares correctly');
} 'overload testing lives';


is_deeply
  is_plain_value {  -value => [] },
  [ [] ],
  '-value recognized'
;

for ([], {}, \'') {
  is
    is_plain_value $_,
    undef,
    'nonvalues correctly recognized'
  ;
}

for (undef, { -value => undef }) {
  is_deeply
    is_plain_value $_,
    [ undef ],
    'NULL -value recognized'
  ;
}

is_deeply
  is_literal_value { -ident => 'foo' },
  [ 'foo' ],
  '-ident recognized as literal'
;

is_deeply
  is_literal_value \[ 'sql', 'bind1', [ {} => 'bind2' ] ],
  [ 'sql', 'bind1', [ {} => 'bind2' ] ],
  'literal correctly unpacked'
;


for ([], {}, \'', undef) {
  is
    is_literal_value { -ident => $_ },
    undef,
    'illegal -ident does not trip up detection'
  ;
}

done_testing;
