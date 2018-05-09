#!/bin/bash
git add .
git commit -m "`date`"
expect <<EOF > /dev/null 2>&1
spawn git push origin master
expect "github.com':"
send "hongchaogithub"
expect "@github.com':"
send "nxbxzgrlp2"
expect eof
EOF
