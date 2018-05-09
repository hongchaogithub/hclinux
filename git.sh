#!/bin/bash
#github的提交操作
read -p "请输入代码提交信息，如果直接回车将以日期时间作为代码提交信息：" info
git add .
if [ -z $info ]
then
	git commit -m "`date`"
else
	git commit -m $info
fi

expect <<EOF # > /dev/null 2>&1
spawn git push origin master
expect "github.com':"
send "$1\r\n"
expect "@github.com':"
send "$2\r\n"
expect eof
EOF

#远程触发构建
curl -u admin:$3 -X POST http://182.10.1.55:8080/job/demo/build?token=123456
