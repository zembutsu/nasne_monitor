#!/usr/bin/perl

my $curl = 'curl -s "http://192.168.21.10:64210/status/HDDInfoGet?id=0"';

my $cmd;

open(CMD, "$curl |");
$cmd = <CMD>;
#print $cmd;
close(CMD);

if ($cmd =~ /(\"usedVolumeSize\"\: )(\d+)(, \"freeVolumeSize\"\: )(\d+)/){
	print "used.value $2\n";
	print "free.value $4\n";
} 

exit;

