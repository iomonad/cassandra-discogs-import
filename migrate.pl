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

	# my $urls = $artist->findnodes('.//urls')->to_literal_list();
	# my @namevars = ();
	# my @name_aliases = ();

	$client->execute("INSERT INTO artists (id, name, realname) VALUES (?, ?, ?) USING TTL ?",
			 [$id, $name, $realname, 86400 ], { consistency => "quorum" });
}

$client->disconnect;
