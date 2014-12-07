#!/usr/bin/perl

my $curl = 'curl -s "http://192.168.21.10:64210/status/HDDInfoGet?id=0"';

my $cmd;

open(CMD, "$curl |");
$cmd = <CMD>;
#print $cmd;
close(CMD);

if ($cmd =~ /(\"usedVolumeSize\"\: )(\d+)(, \"freeVolumeSize\"\: )(\d+)/){
	#print "used.value $2\n";
	#print "free.value $4\n";
	system("zabbix_sender -z sakura1.pocketstudio.net -s sibyl2.pocketstudio.net -k nasune_hdd_used -o $2");
	system("zabbix_sender -z sakura1.pocketstudio.net -s sibyl2.pocketstudio.net -k nasune_hdd_free -o $4");
} 

exit;

