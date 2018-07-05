#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use HTTP::Tiny;
use Encode;
use Encode::Guess qw/shift-jis euc-jp 7bit-jis/;
use JSON::PP qw/encode_json decode_json/;

my $config = load_config( "$ENV{HOME}/.pushbullet.json" );
my $access_token = $ENV{PUSHBULLET_ACCESS_TOKEN} // $config->{pushbullet_access_token} // "";
my $endpoint = "https://api.pushbullet.com/v2/pushes";

my $title = $ARGV[0];
my $body = "";
while ( <STDIN> ) {
    chomp $_;
    $body .= "$_\n";
}

my $decoder = Encode::Guess->guess( $body );
if ( ref $decoder ) {
    $body = $decoder->decode( $body );
}

my $json_data = {
    title => $title,
    body => $body,
    type => "note",
};

my $headers = {
    'Access-Token' => $access_token,
    'Content-Type' => 'application/json',
};

my $ua = HTTP::Tiny->new;
my $response = $ua->post( $endpoint, {
    'headers' => \%$headers,
    'content' => encode_json( $json_data ),
} );

unless ( $response->{success} ) {
    print STDERR Dumper $response;
    exit 1;
}
exit 0;

sub load_config {
    my $file = shift;
    return {} unless -f $file;
    open my $fh, '<', $file or die $!;
    $config = decode_json( join '', <$fh> );
    close $fh;
    return $config;
}
