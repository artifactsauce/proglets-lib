#!/usr/bin/env perl

=head1 NAME

generate-skelton-perl

=head1 SYNOPSIS

generate-skelton-perl [OPTIONS] SCRIPT_NAME

  OPTIONS:
    --disable-summary
    --disable-config
    --disable-log
    --author-name STRING
    --author-email STRING
    --author-twitter STRING
    --overwrite
    --verbose
    --version
    --usage
    --help
    --man

=head1 DESCRIPTION

Generate a perl script scaffold with Perl Best Practice rules.

=head1 DEPENDENCIES

=over

=item * Pod::Usage

=item * IO::Prompter

=item * DateTime

=item * Template

=back

=head1 AUTHOR

Kenji Akyiama <artifactsauce@gmail.com> (@artifactsauce)

=cut

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use IO::Prompt::Simple;
use FindBin($Bin)
use File::Basename;
use DateTime;
use Template;
use Data::Dumper;

use version; our $VERSION = qv('0.2.0');

my $config = {};

Getopt::Long::Configure("bundling");
GetOptions(
    'disable-summary'  => \$config->{disable_summary},
    'disable-config'   => \$config->{disable_config},
    'disable-log'      => \$config->{disable_log},
    'author-name=s'    => \$config->{author_name},
    'author-email=s'   => \$config->{author_email},
    'author-twitter=s' => \$config->{author_twitter},
    'author-github=s'  => \$config->{author_github},
    'overwrite'        => \$config->{overwrite},
    'verbose'          => \$config->{verbose},
    'version'          => sub { print "$0 $VERSION" && exit },
    'usage'            => sub { pod2usage( -verbose => 0 ) },
    'help'             => sub { pod2usage( -verbose => 1 ) },
    'man'              => sub { pod2usage( -verbose => 2 ) },
    );

@ARGV > 0 && @ARGV < 2 or pod2usage();

my $file_path = $ARGV[0];
$config->{file_path} = $file_path;
$config->{script_name} = basename( $file_path );

confirm_overwriting_file( $config );
confirm_author_information( $config );

my $time_zone = DateTime::TimeZone->new( name => 'local' );
$config->{year} = DateTime->now( time_zone => $time_zone )->year;

my $tmpl_config = {
    INCLUDE_PATH => $Bin.'/../share/generate/skeleton',  # or list ref
    INTERPOLATE  => 1,               # expand "$var" in plain text
    POST_CHOMP   => 1,               # cleanup whitespace
    PRE_PROCESS  => 'header',        # prefix each template
    EVAL_PERL    => 1,               # evaluate Perl code blocks
};

my $tmpl = Template->new($tmpl_config);
my $template_file = "perl.tt";
$tmpl->process( $template, $config, $file_path ) or die $tmpl->error();

print "[INFO] Success to craete $config->{file_path}.\n"
    if $config->{verbose};

chmod 0755, $file_path;
print "[INFO] Added permission to execute.\n"
    if $config->{verbose};

exit;

sub confirm_author_information {
    my $config = shift;

    $config->{author_name} = prompt "Author Name"
        if ! defined $config->{auhor_name};

    warn "[WARN] Author name was set empty.\n"
        if $config->{author_name} eq "" && $config->{verbose};

    $config->{author_email} = prompt "Author E-mail"
        if ! defined $config->{author_email};

    warn "[WARN] Author e-mail was set empty.\n"
        if $config->{author_name} eq "" && $config->{verbose};
}

sub confirm_overwriting_file {
    my $config = shift;

    return if $config->{overwrite};
    return if ! -f $config->{file_path};

    warn "[WARN] $config->{file_path} already exists.\n"
        if $config->{verbose};

    my $answer = prompt "Overwrite $config->{file_path}?", { 'anyone' => ['y','n'] };
    if ( $answer eq "y" ) {
        warn "[WARN] The existing file will not be recovered.\n"
            if $config->{verbose};
    }
    else {
        warn "[ERROR] Please retry with other file name.\n"
            if $config->{verbose};
        exit 1;
    }
}
