use strict;
my %count;

package T;
use Class::Random choose => ['A'],['B'];

sub new{
  bless {};
}

package S;
use Class::Random shuffle => qw(A B);

sub new{
  bless {};
}

package A;
sub foo{
  ++$count{a_foo};
}
sub bar{
  ++$count{a_bar};
}

package B;

sub foo{
  ++$count{b_foo};
}
sub bar{
  ++$count{b_bar};
}

package main;

foreach(
  [choose => 'T'],
  [shuffle => 'S'],
){
  my($mode,$class)=@$_;
  my $t=$class->new;

  %count=();
  for(1..100){
    $t->foo;
    $t->bar;
  }

  my $ok=1;
  foreach(qw(a_foo a_bar b_foo b_bar)){
    if($count{$_}<25){
      print "Failed to call $_ enough times to pass $mode test\n";
      $ok=0;
    }
  }
  print "$mode OK\n" if $ok;
}

