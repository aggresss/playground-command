#/usr/bin/env bash

# test trap command
trap "echo 'Sorry! I have trapped Ctrl-C'" SIGINT
trap "echo 'OK! exit.'" EXIT

echo This is a test script

count=1
while [ $count -le 10 ]
do
  echo "Loop $count"
  sleep 1
  count=$[ $count + 1 ]
done

echo The end.

