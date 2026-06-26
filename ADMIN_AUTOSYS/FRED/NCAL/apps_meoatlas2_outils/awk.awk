#!/usr/bin/awk -f

$1 ~ "^( )*[a-z].*|^( )*B.*" {job=$0}
$1 == "[STARTJOB]" {status=$1 ; date=$2 ; heure=$3}
{
if(status=="[STARTJOB]"){
gsub(/\[/,"",status)
gsub(/\]/,"",status)
print job,status,"\t",date,"\t",heure}
}
