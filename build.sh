#!/bin/zsh
echo "Start Build !"
work_path=$(dirname $(readlink -f $0))
cd ${work_path}

# 生成最新的主题
node theme.js
# 编译成CSS

for theme in ${work_path}/assets/css/theme*
do
    # echo $theme
    lessc $theme static/css/${${theme%.*}##*/}.css
done

docker build -t docker.ednet.cn/template-c .
docker push docker.ednet.cn/template-c
docker rmi $(docker images -f "dangling=true" -q)