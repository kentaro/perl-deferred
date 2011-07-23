package Deferred::Queue;
use strict;
use warnings;
use Try::Tiny;

use Deferred::Function;

use Class::Accessor::Lite (
    rw => [qw(
        callbacks
        fired
        firing
        cancelled
    )],
);

sub new {
    my $class = shift;
    bless {
        callbacks => [],
        fired     => 0,
        firing    => 0,
        cancelled => 0,
    }, $class
}

sub done {
    my ($self, @callbacks) = @_;
    my $fired;

    if ($self->fired) {
        $fired = $self->fired;
        $self->fired(0);
    }

    push @{$self->callbacks}, (map {
        Deferred::Function->new($_)
    } @callbacks);

    if ($self->fired) {
        $self->resolve(@{$fired || []});
    }

    $self;
}

sub resolve {
    my ($self, @args) = @_;
    $self->firing(1);

    try {
        my @coros;

        while (my $callback = shift @{$self->callbacks}) {
            push @coros, $callback->to_coro(@args);
        }

        $_->join for @coros;
    }
    finally {
        $self->fired([@args]);
        $self->firing(0);
    };

    $self;
}

sub is_resolved {
    my $self = shift;
    !!($self->firing || $self->fired);
}

sub cancel {
    my $self = shift;
       $self->cancelled(1);
       $self->callbacks([]);
       $self;
}

sub is_cancelled {
    my $self = shift;
    !!$self->cancelled;
}

!!1;
