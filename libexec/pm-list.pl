#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use ExtUtils::Installed;
use List::Util;

my %options = ();
GetOptions(
    'table!' => \$options{table},
);

my $ei = ExtUtils::Installed->new;
my $length = List::Util::max( map { length($_) } $ei->modules );

if ( defined $options{'table'} && $options{'table'} ) {
    require Text::SimpleTable;
    my $table = Text::SimpleTable->new( $length, 10 );
    $table->row( 'Module Name', 'Version' );
    $table->hr;
    $table->row( $_, $ei->version($_) ) for $ei->modules;
    print $table->draw;
}
else {
    printf "%-${length}s  %s\n", $_, $ei->version($_) for $ei->modules;
}
