
#!/usr/bin/perl

#
# E.Plicht (c) 2021
#

use strict;
use warnings;
use 5.010;


use HTML::TreeBuilder;
use Data::Printer;

binmode(STDOUT, ":utf8");

my $template = "./workshop-table-template.html";
my $h = HTML::TreeBuilder->new;
$h->implicit_body_p_tag( 1 );
$h->p_strict (1 );
$h->parse_file( $template );
$h->warn( 1 );

my $headline =


$h->dump;
