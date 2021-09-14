systemctl stop $1
service_dir=services/$1
if [[ "$1" =~ _py$ ]];
then
    cd $service_dir
    python3 main.py
else
    cd $service_dir
    cargo r
fi