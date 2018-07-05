#!/usr/bin/env perl

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;

my $endpoint = "https://www.google.co.jp/";

my %attributes = (
    agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
);

my $params = {
};

my $headers = {
};

my $ua = HTTP::Tiny->new( %attributes );
my $response = $ua->post( $endpoint, {
    'headers' => $headers,
    'content' => $params,
} );

unless ( $response->{success} ) {
    print STDERR Dumper $response;
    exit 1;
}
exit 0;
