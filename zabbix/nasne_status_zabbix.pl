#!/usr/bin/perl

my $curl;
$curl = 'curl -s "http://192.168.21.10:64210/status/boxStatusListGet"';

my $cmd;
my $rec, $play, $live;
open(CMD, "$curl |");
        $cmd = <CMD>;
        #if ($cmd =~ /(tvTimerInfoStatus)/){
        if ($cmd !~ /("nowId": "")/){
                #print "rec.value 1\n";
		$rec = "1";
        } else {
                #print "rec.value 0\n";
		$rec = "0";
        }

close(CMD);

$curl = 'curl -s "http://192.168.21.10:64210/status/dtcpipClientListGet"';

open(CMD, "$curl |");

	$cmd = <CMD>;
	
	if ($cmd =~ /(content)/){
		#print "play.value 1\n";
		$play = "1";
	} else {
		#print "play.value 0\n";
		$play = "0";
	}
	
	if ($cmd =~ /(liveInfo)/){
	        #print "live.value 1\n";
		$live = "1";
	} else {
	        #print "live.value 0\n";
		$live = "0";
	}

close(CMD);

system("zabbix_sender -z sakura1.pocketstudio.net -s sibyl2.pocketstudio.net -k nasne_status_rec -o $rec");
system("zabbix_sender -z sakura1.pocketstudio.net -s sibyl2.pocketstudio.net -k nasne_status_play -o $play");
system("zabbix_sender -z sakura1.pocketstudio.net -s sibyl2.pocketstudio.net -k nasne_status_live -o $live");


exit;

