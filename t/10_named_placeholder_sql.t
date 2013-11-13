use strict;
use Test::More;
use SQL::Placeholder::Named;

subtest 'simple, context' => sub {
    subtest 'no variable' => sub {
        subtest 'in list context' => sub {
            my ($sql, @binds) = named_placeholder_sql('?');
            is $sql, '?';
            is_deeply \@binds, [];
        };
        subtest 'in scalar context' => sub {
            my $sql = named_placeholder_sql('?');
            is $sql, '?';
        };
    };

    subtest 'with variable' => sub {
        my %vars = ( foo => 'hoge' );
        subtest 'in list context' => sub {
            my ($sql, @binds) = named_placeholder_sql('?:foo', \%vars);
            is $sql, '?';
            is_deeply \@binds, ['hoge'];
        };
        subtest 'in scalar context' => sub {
            my $sql = named_placeholder_sql('?:foo', \%vars);
            is $sql, '?';
        };
    };

    subtest 'with variable, but does not exist' => sub {
        my %vars = ( foo => 'hoge' );
        subtest 'in list context' => sub {
            my ($sql, @binds) = named_placeholder_sql('?:bar', \%vars);
            is $sql, '?';
            is_deeply \@binds, [undef];
        };
        subtest 'in scalar context' => sub {
            my $sql = named_placeholder_sql('?:bar', \%vars);
            is $sql, '?';
        };
    };
};

subtest 'basic' => sub {
    subtest 'scalar variable' => sub {
        my ($sql, @binds) = named_placeholder_sql(
            'SELECT foo FROM bar WHERE id = ?:id',
            { id => 'hoge' },
        );
        is $sql, 'SELECT foo FROM bar WHERE id = ?';
        is_deeply \@binds, ['hoge'];
    };

    subtest 'arrayref variable' => sub {
        my ($sql, @binds) = named_placeholder_sql(
            'SELECT foo FROM bar WHERE id IN ( ?:id )',
            { id => ['hoge', 'fuga', 'piyo'] },
        );
        is $sql, 'SELECT foo FROM bar WHERE id IN ( ?,?,? )';
        is_deeply \@binds, ['hoge', 'fuga', 'piyo'];
    };
};

done_testing;

