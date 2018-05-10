#!/bin/bash
#检查是否安装了必须的软件
dpkg -l|grep expect|awk '{print $2}'|grep -v .expect.
if [ $? -ne 0 ] 
then
apt update
apt install expect << EOF
y
EOF
fi

#给参数赋值
while getopts "u:g:j:" opt;
do
        case $opt in
        u)
		githubuser=$OPTARG
        ;;
        g)
                githubpw=$OPTARG
        ;;
	j)
                jenkinspw=$OPTARG
        ;;
        \?)
                echo "invalid option: $OPTARG"
        ;;
        esac
done

#检查是否输入了参数
while [ -z $githubuser ]; do read -p "请输入github用户名：" githubuser; done
while [ -z $githubpw ]; do read -s -p "请输入github密码：" githubpw;echo ""; done
while [ -z $jenkinspw ]; do read -s -p "请输入jenkins密码：" jenkinspw;echo ""; done

#这是用文件存储用户名和密码的方式，方便，但比较不安全
#githubuser=`sed -n "1p" /usr/share/jengit.txt`
#jenkinspw=`sed -n "2p" /usr/share/jengit.txt`

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
send "$githubuser\n"
expect "@github.com':"
send "$githubpw\n"
expect eof
EOF

#远程触发构建
curl -u admin:$jenkinspw -X POST http://182.10.1.55:8080/job/demo/build?token=123456
