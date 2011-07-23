package Deferred::Function;
use strict;
use warnings;
use Coro;

sub new {
    my ($class, $function) = @_;
    bless { function => $function }, $class;
}

sub to_coro {
    my ($self, @args) = @_;
    async { $self->{function}->(@_) } @args;
}

!!1;
