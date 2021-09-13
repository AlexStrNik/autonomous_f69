services=$(find services/**/requirements.txt)
for service in $services; do
    pip3 install -r $service;
done;