#!/usr/bin/perl

#
# E.Plicht (c) 2021
# - Daten vom ZTL Pretix lesen
# - Daten in ne HTML Template einbauen
# - Graphik von HTML Seite erzeiugen, für Darstellung im Infobeamer ZTL
#
# Die Authentication von pretix verwendet einfache token based auth, kein OAuth2 (es ginge auch OAuth2).
#
# History:
# 15. Sep. 2021: Angefangen

use strict;
use warnings;
use 5.010;

use MIME::Base64;
use LWP::UserAgent;
use JSON::XS;
use Data::Printer;
use Data::Dumper;

binmode(STDOUT, ":utf8");

my $pretix_host = $ENV{ZTL_PRETIX_HOST};
my $pretix_token = $ENV{ZTL_PRETIX_TOKEN};

my $endpoint_organizers = '/api/v1/organizers/';
my $endpoint_events     = '/api/v1/organizers/##SLUG##/events/';

my $rv = issue_request( $pretix_host, $endpoint_organizers, 'GET', $pretix_token, '' );
#p $rv;

my $org  = $$rv{results}[0]{name};
my $slug = $$rv{results}[0]{slug};

$endpoint_events =~ s/##SLUG##/$slug/;

$rv = issue_request( $pretix_host, $endpoint_events . '?is_future=1&ordering=date_from', 'GET', $pretix_token, '' );

my $event_count = $$rv{count};
my $events_nextpage = $$rv{next};
say "We have $event_count events.";
say "There is a next page. ($events_nextpage)" if(defined($events_nextpage));

foreach my $event (@{$$rv{results}}) {
    say "slug: ", $$event{slug};
    say "live: ", $$event{live};
    say "testmode: ", $$event{testmode};
    say "is_public: ", $$event{is_public};
    say "from: ",  $$event{date_from};
    say "meta: ",  np($$event{meta_data});
    print "\n";

}

#p  $rv;

