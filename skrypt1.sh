#!/bin/bash
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | cut -d '"' -f 2 | sed "s#.*/##" | grep "cdlinux" > wynik.txt

grep "thttpd.log" cdlinux.www.log | cut -d " " -f 1,7,9 | grep "200" | cut -d ':' -f 2 | cut -d ' ' -f 1,2 | grep "cdlinux" | sort -u | cut -d '/' -f 6 | grep ".iso" | grep -v "Cache" | grep -v ".sh"  >> wynik.txt

cat <  wynik.txt | grep ".\iso" | sort | uniq -c | sort

