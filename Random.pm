package Class::Random;

use overload '""','stringify';
use strict;
use Carp;
use vars qw($VERSION);

$VERSION=0.1;

sub stringify{
  my($self)=@_;

  if($self->{mode} eq 'choose'){
    @{$self->{isa}}=($self,@{$self->{list}[rand @{$self->{list}}]});
  }elsif($self->{mode} eq 'shuffle'){
    my @list=@{$self->{list}};
    my @isa;
    while(@list){
      push @isa,splice @list,rand @list,1;
    }
    @{$self->{isa}}=($self,@isa);
  }
  'Class::Random::Empty';
}

sub import{
  my($pack,$mode,@list)=@_;

  if($mode eq 'choose'){
    foreach(@list){
      ref eq 'ARRAY'
        or croak "choose argument must be list of lists";
    }
  }
    

  my $self=bless {
    mode => $mode,
    list => \@list,
    isa => do{
      no strict 'refs';
      \@{caller().'::ISA'};
    },
  };
  unshift @{$self->{isa}},$self;
  "$self"; # Force setting of caller's @ISA
}

package Class::Random::Empty;

1;

__END__

=head1 NAME

Class::Random - Random ancestry for each method call

=head1 SYNOPSIS

  package Ridiculous1;
  use Class::Random choose => ['A'],['B'];

  package Ridiculous2;
  use Class::Random choose => qw(C D);

=head1 DESCRIPTION

This module allows you to create classes which randomly change their
ancestors every time a method is called. This is done simply by using the
module, passing a parameter list which dictates the required behaviour.
Currently two behaviours are possible, determined by the first argument
in the C<use Class::Random> line:

=over 4

=item choose

The C<choose> behaviour is given a list of arrays, one of which will be chosen
at random to be the calling module's C<@ISA> when a method is called.

=item shuffle

The C<shuffle> behaviour is given a normal list of class names, which is
shuffled each time a method is called.

=back

=head1 BUGS

Due to perl's normal sensible strategy of method caching, if the same method
is called repeatedly, without any others being called in between, it will
always call the same method.

=head1 AUTHOR

Peter Haworth E<lt>pmh@edison.ioppublishing.comE<gt>

