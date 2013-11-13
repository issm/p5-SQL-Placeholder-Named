package SQL::Placeholder::Named;
use 5.008005;
use strict;
use warnings;
our $VERSION = "0.01";

use parent qw(Exporter);

our @EXPORT = qw(named_placeholder_sql);

sub named_placeholder_sql {
    my ($sql, $vars) = @_;
    my ($sql_gen, @binds) = ($sql);
    $sql_gen =~ s{\?:(.+)\b}{
        my ($ph, @b) = _handle($1, $vars);
        push @binds, @b;
        $ph;
    }gex;
    return wantarray ? ($sql_gen, @binds) : $sql_gen;
}

sub _handle {
    my ($name, $vars) = @_;
    my ($ph, @b);
    my $var = $vars->{$name};
    if ( ref($var) eq 'ARRAY' ) {
        $ph = join ',', map '?', @$var;
        push @b, @$var;
    }
    else {
        $ph = '?';
        push @b, $var;
    }
    return ($ph, @b);
}


1;
__END__

=encoding utf-8

=head1 NAME

SQL::Placeholder::Named - It's new $module

=head1 SYNOPSIS

    use SQL::Placeholder::Named;

=head1 DESCRIPTION

SQL::Placeholder::Named is ...

=head1 LICENSE

Copyright (C) issm.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=cut

