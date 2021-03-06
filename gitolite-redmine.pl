#!/usr/bin/env perl

#TODO
# do the curlopt_capath bit from this instead of just turrning off ssl_verify
# $curl->setopt(CURLOPT_SSL_VERIFYPEER, 0);
# http://www.tek-tips.com/viewthread.cfm?qid=1460875


use strict;
use warnings;
use Data::Dumper;               # Perl core module
use WWW::Curl::Easy;
use YAML qw(LoadFile);
use JSON;
 use feature "switch";
my $config;

main();

sub main {

  $config = LoadFile('config.yaml');
  print "The API key is ".$config->{'api_key'}."\n";
  print "The Redmine URL is ".$config->{'redmine_url'}."\n";

  my $projects_list_url = $config->{'redmine_url'}."/projects.json\n";
  my($projects_list) = &returnjson($projects_list_url);

  foreach my $project (@{$projects_list->{'projects'}}){
      print "repo ".$project->{'identifier'}."\n";
      my $prefix = "/projects/".$project->{'id'};
      my $members_list_url = $config->{'redmine_url'}."$prefix/memberships.json\n";
      my($members_list) = &returnjson($members_list_url);
      each_member ($members_list->{'memberships'});
      #print Dumper $members_list;
      #exit 0;
      print "\n";

  }
}

sub returnjson {
    my($request_url) = @_;
    my $curl = WWW::Curl::Easy->new;
    #my $projects_list_url = $config->{'redmine_url'}."/projects.json\n";
    #print $projects_list_url;

    $curl->setopt(CURLOPT_HEADER,0);
    $curl->setopt(CURLOPT_SSL_VERIFYPEER, 0);
    $curl->setopt(CURLOPT_URL, $request_url);

    my @myheaders=(); 
    $myheaders[0] = "X-Redmine-API-Key: ".$config->{'api_key'}; 
    $myheaders[1] = "User-Agent: Perl interface for libcURL"; 

    $curl->setopt(CURLOPT_HTTPHEADER, \@myheaders);

    # A filehandle, reference to a scalar or reference to a typeglob can be used here.
    my $response_body;
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);

    # Starts the actual request
    my $retcode = $curl->perform;

    my $curl_response;
    # Looking at the results...
    if ($retcode == 0) {
        #print("Transfer went ok\n");
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        # judge result and next action based on $response_code
        #print("Received response: $response_body\n");
        $curl_response = $response_body;
    } else {
        # Error code, type of error, error message
        print("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
    }
    my $perl_scalar = decode_json $curl_response;
    return $perl_scalar;
}




sub each_member {
    my($memberships) = @_;
    foreach my $member (@$memberships){
        if (exists $member->{'user'}) {
            print "    ";
            given ($member->{'roles'}[0]->{'name'}) {
                when("Manager") {
                    print "RW+     =   ";
                }
                when("Developer") {
                    print "RW+     =   ";
                }
                when("Reporter") {
                    print "R       =   ";
                }
                when("Watcher") {
                    print "R       =   ";
                }
                when("Editor") {
                    print "RW+     =   ";
                }
                when("Viewer") {
                    print "R       =   ";
                }
                default {}
            }
            #print $member->{'roles'}[0]->{'name'}." ";
            print $member->{'user'}->{'name'}."\n";
        }
    }
}

