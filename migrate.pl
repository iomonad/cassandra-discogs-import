#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use Cassandra::Client;
use XML::LibXML::Reader;

unless (@ARGV == 2) {
    print "usage: migrate.pl <file> <nodelist>\n";
    exit(1);
}

my $client= Cassandra::Client->new(
    contact_points => [ '127.0.0.1', '192.168.0.1' ],
    keyspace => 'discogs'
);

$client->connect();

my ($filename, $nodename) = @ARGV;

my $reader = XML::LibXML::Reader->new(location => $filename)
    or die "cannot read file '$filename': $!\n";

while ($reader->read) {
        next unless $reader->nodeType == XML_READER_TYPE_ELEMENT;
	next unless $reader->name eq $nodename;

	my $artist = $reader->copyCurrentNode(1);

	my $id = $artist->findvalue('./id');
	my $name = $artist->findvalue('./name');
	my $realname = $artist->findvalue('./realname');
	my $data_quality = $artist->findvalue('./data_quality');

	my $_urls = $artist->findnodes('//urls')->to_literal();
	my @urls = grep /\S/, split /^/m, $_urls;
	my $_nvars = $artist->findnodes('//namevariations')->to_literal();
	my @nvars = grep /\S/, split /^/m, $_nvars;
	my $_nalias = $artist->findnodes('//aliases')->to_literal();
	my @nalias = grep /\S/, split /^/m, $_nvars;

	$client->execute("INSERT INTO artists (id, name, realname, data_quality, urls, name_variation) VALUES (?, ?, ?, ?, ?, ?) USING TTL ?",
			 [$id, $name, $realname, $data_quality, @urls, @nvars, 86400 ], { consistency => "quorum" });
}

$client->shutdown();
