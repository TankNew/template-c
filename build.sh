#!/bin/zsh
echo "Start Build !"
work_path=$(dirname $(readlink -f $0))
cd ${work_path}

lessc assets/css/theme.blue.less static/css/theme.blue.css
lessc assets/css/theme.dark-green.less static/css/theme.dark-green.css
lessc assets/css/theme.green.less static/css/theme.green.css
lessc assets/css/theme.orange.less static/css/theme.orange.css
lessc assets/css/theme.purple.less static/css/theme.purple.css
lessc assets/css/theme.red.less static/css/theme.red.css

docker build -t docker.ednet.cn/template-c .
docker rmi $(docker images -f "dangling=true" -q)
