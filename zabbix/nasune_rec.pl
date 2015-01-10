#!/usr/bin/perl

my $nasune_addr = '192.168.21.10';
my $datafile    = '/tmp/zabbix_nasune.dat';
my $curl = 'curl -s "http://".$nasune_addr.":64210/status/boxStatusListGet"';

my $cmd,$recording;
open(CMD, "$curl |");
	$cmd = <CMD>;
	$recording = 1 if ($cmd =~ /(tvTimerInfoStatus)/);
close(CMD);

exit if(!$recording);

my $curl	= 'curl -s "http://'.$nasune_addr.':64210/status/boxStatusListGet"';
my $cmd, $rec, $network, $transport, $service;
open(CMD, "$curl |");
	$cmd = <CMD>;

	if ($cmd =~ /("networkId": )(\d+)(, "transportStreamId": )(\d+)(, "serviceId": )(\d+)/){
		$network = $2;
		$transport = $4;
		$service = 6;
	}
	$network = $2   if ($cmd =~ /("networkId": )(\d+)/);
	$transport = $2 if ($cmd =~ /("transportStreamId": )(\d+)/);
	$service = $2   if ($cmd =~ /("serviceId": )(\d+)/);


close(CMD);


exit if (!$network);

my $channel, $title, $desc, $date, $year, $month, $day, $hour, $min, $sec, $log;

my $curl = 'curl -s "http://'.$nasune_addr.':64210/status/channelInfoGet2?networkId='.$network.'&transportStreamId='.$transport.'&serviceId='.$service.'&withDescriptionLong=0"';

open(CMD, "$curl |");
	$cmd = <CMD>;

	$channel = $2   if ($cmd =~ /("serviceName": ")(.*?)(\")/);
	$title = $2.$3  if ($cmd =~ /("title": ")(.*?)(」)/);
	$desc = $2      if ($cmd =~ /("description": ")(.*?)(\")/);
	$date = $2      if ($cmd =~ /("startDateTime": ")(.*?)(\")/);
	$year   = substr($date, 0, 4);
	$month  = substr($date, 5, 2);
	$day    = substr($date, 8, 2);
	$hour   = substr($date, 11, 2);
	$min    = substr($date, 14, 2);
	$sec    = substr($date, 17, 2);

close(CMD);

$log = $year.$month.$day.'.'.$hour.$min.$sec.' '.$title.' ('.$channel.') '.$desc;

my $dat;
open(DAT, $datafile);
	$dat = <DAT>;
close(DAT);

if ($dat ne $log && $log) {
	# sender
	system("zabbix_sender -z <zabbix_host> -s <server_name> -k nasune_rec_log -o \"$log\"");

	open(DAT, ">"."$datafile");
	print DAT $log;
	close(DAT);
}

exit;
