units=$(find services/**/*.service)
for unit in $units; do
    unit_name=$(filename $unit);
    cp unit /etc/systemd/system/$unit_name;
    systemctl enable $unit_name;
    systemctl start $unit_name;
done;