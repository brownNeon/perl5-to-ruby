# -*- perl -*-
use P2R;
use Test::Simple tests => 26;
use Test::P2R;

## variable names
ok_p2r('$a_1;', 'a_1;', 'scalar lower-bar-num');
ok_p2r('$a_A;', 'a_A;', 'scalar lower-bar-upper');
ok_p2r('$aBc;', 'aBc;', 'scalar lower-upper-lower');
ok_p2r('$D;', 'd;', 'scalar upper one');
ok_p2r('$ABC;', 'abc;', 'scalar upper multi');
ok_p2r('$Abc;', 'abc;', 'scalar capitalized');
ok_p2r('$_ = 0;', '$_ = 0;', 'scalar $_' );
ok_p2r('$_ = $+;', '$_ = $+;', 'scalar $_ and other magic-var');


# assignments
ok_p2r(q|$a = 1;|, 
       'a = 1;',
       "scalar assign"
    );
ok_p2r(q|@abcd2 = ('fee','fi','fo','fum');|,
       q|abcd2=['fee','fi','fo','fum'];|,
       'list assign as list');

ok_p2r(q|@abcd = qw(fee fi fo fum);|,
       'abcd = %w(fee fi fo fum);',
       "list assign with qw/%w");

ok_p2r(q|%zoot2 = ( 'a' => 'b' );|,
       q|zoot2={'a'=>'b'};|,
       'hash assign from list');

ok_p2r(q|$zoot = { 'a' => "h1", 'b' => "h2" };|, 
       q|zoot = { 'a' => "h1", 'b' => "h2" };|,
       "hash-scalar assign from hash w/ fatcomma"
    );

ok_p2r('use constant FOO1 => 11 ;', 'FOO1 = 11 ;', 'constant:1');
ok_p2r('use constant FOO2 =>12 ;',  'FOO2 =12 ;',  'constant:2');
ok_p2r('use constant FOO3=> 13 ;',  'FOO3= 13 ;',  'constant:3');
ok_p2r('use constant FOO4=>14 ;',   'FOO4=14 ;',   'constant:4');

## remove my/local/our scope directives
ok_p2r(q|local $tail = 'tail';|,
       "tail = 'tail';",
       "local assign removal" );
ok_p2r(q|our $wing = 'wing';|,
       q|wing = 'wing';|,
       "our assign removal");
ok_p2r(q|my $foo = "0";|,
       q|foo = "0";|,
       "my assign removal");

## array access and length 

ok_p2r('$b = $abcd[FOOBAR];',
       'b=abcd[FOOBAR];',
       'array access with constant');

ok_p2r('$b = $abcd[1];',
       'b=abcd[1];',
       'array access with integer');

ok_p2r(q|$ABCD_LENGTH = $#abcd;|, 
       q|abcd_length = abcd.length;|,
       '$# to .length');

## hash settor, gettor

%zz = {};
ok_p2r(q|$zz{'aaaz'} = "bbbz\n";|,
       q|zz['aaaz'] = "bbbz\n";|,
       'hash settor');

ok_p2r(q|$b = $zz{'aaaz'};|,
       q|b = zz['aaaz'];|,
       'hash gettor');

# broken : hash as comma separated list
# %yy = ('lh_key', "list-hash-value\n");
# print $yy{'lh_key'};

ok_p2r(q|%yy = ('fch_key' => "fatcomma-hash-value");|,
       q|yy = {'fch_key' => "fatcomma-hash-value"};|,
       'hash as fatcomma separated list');


