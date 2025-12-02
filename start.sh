#! /bin/bash
echo $RANDOM | md5sum  | awk '{print "ssi{"$1"}"}' > flag/user.txt
echo $RANDOM | md5sum  | awk '{print "ssi{"$1"}"}' > flag/root.txt
echo $RANDOM | md5sum  | awk '{print "ssi{"$1"}"}' > flag/flag.txt

docker compose -p web-lab up -d
