#!/usr/bin/perl

my $curl = 'curl -s "http://192.168.21.10:64210/status/boxStatusListGet"';

my $cmd;
open(CMD, "$curl |");
        $cmd = <CMD>;
        #if ($cmd =~ /(tvTimerInfoStatus)/){
        if ($cmd !~ /("nowId": "")/){
                print "rec.value 1\n";
        } else {
                print "rec.value 0\n";
        }

close(CMD);

my $curl = 'curl -s "http://192.168.21.10:64210/status/dtcpipClientListGet"';

open(CMD, "$curl |");

	$cmd = <CMD>;
	
	if ($cmd =~ /(content)/){
		print "play.value 1\n";
	} else {
		print "play.value 0\n";
	}
	
	if ($cmd =~ /(liveInfo)/){
	        print "live.value 1\n";
	} else {
	        print "live.value 0\n";
	}

close(CMD);


exit;

