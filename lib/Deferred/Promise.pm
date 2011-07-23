package Deferred::Promise;
use strict;
use warnings;

sub new {
    my ($class, $deferred) = @_;
    bless { deferred => $deferred }, $class;
}

for my $method (qw(
    done
    fail
    is_resolved
    is_rejected
    promise
    then
    always
    pipe
)) {
    no strict 'refs';

    *{__PACKAGE__."\::$method"} = sub {
        shift->{deferred}->$method(@_)
    }
}

!!1;
