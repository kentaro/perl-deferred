package Deferred;
use 5.008001;
use strict;
use warnings;

our $VERSION = '0.01';

use Coro;

use parent 'Exporter';
our @EXPORT = qw(deferred);

use Class::Accessor::Lite (
    rw => [qw(
        done_queue
        fail_queue
    )],
);

use Deferred::Queue;
use Deferred::Promise;
use Deferred::Function;

sub deferred (;@) { __PACKAGE__->new(@_) }

sub new {
    my ($class, $callback) = @_;
    my $self = bless {
        done_queue    => Deferred::Queue->new,
        fail_queue    => Deferred::Queue->new,
    }, $class;

    if ($callback) {
        async { $callback->(@_) } $self;
    }

    $self;
}

sub done {
    my ($self, @callbacks) = @_;
    $self->done_queue->done(@callbacks);
    $self;
}

sub fail {
    my ($self, @callbacks) = @_;
    $self->fail_queue->done(@callbacks);
    $self;
}

sub resolve {
    my ($self, @args) = @_;
    $self->done_queue->resolve(@args);
    $self;
}

sub is_resolved { shift->done_queue->is_resolved }

sub reject {
    my ($self, @args) = @_;
    $self->fail_queue->resolve(@args);
    $self;
}

sub is_rejected { shift->fail_queue->is_resolved }

sub then {
    my ($self, $done_callbacks, $fail_callbacks) = @_;
    $done_callbacks = ref $done_callbacks eq 'ARRAY' ? $done_callbacks : [$done_callbacks];
    $fail_callbacks = ref $fail_callbacks eq 'ARRAY' ? $fail_callbacks : [$fail_callbacks];

    $self->done(@$done_callbacks)
         ->fail(@$fail_callbacks);
}

sub always {
    my ($self, @callbacks) = @_;
    $self->done(@callbacks)
         ->fail(@callbacks);
}

sub pipe {

}

sub promise {
    my $self = shift;
    Deferred::Promise->new($self);
}

!!1;

__END__

=encoding utf8

=head1 NAME

Deferred -

=head1 SYNOPSIS

  use Deferred;

=head1 DESCRIPTION

Deferred is

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentarok@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kentaro Kuribayashi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
