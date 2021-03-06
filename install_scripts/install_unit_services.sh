#!/bin/bash
units=$(find services/**/*.service)
for unit in $units; do
    unit_name=$(basename $unit);
    cp $unit /etc/systemd/system/$unit_name;
    systemctl enable $unit_name;
    systemctl restart $unit_name;
done;