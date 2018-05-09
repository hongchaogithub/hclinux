#!/bin/bash
#检查是否输入了参数
if [ -z $1 ]
then
	read -p "请输入github用户名：" $githubuser
else
 	githubuser=$1
fi

if [ -z $2 ]
then
        read -p "请输入github密码：" $githubpw
else
        githubpw=$2
fi

if [ -z $3 ]
then
        read -p "请输入jenkins密码：" $jenkinspw
else
        jenkinspw=$3
fi


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
send "$githubuser\r\n"
expect "@github.com':"
send "$githubpw\r\n"
expect eof
EOF

#远程触发构建
curl -u admin:$jenkinspw -X POST http://182.10.1.55:8080/job/demo/build?token=123456
