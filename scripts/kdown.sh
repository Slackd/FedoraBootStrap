#!/usr/bin/bash

base_url=https://cdn.kernel.org/pub/linux/kernel/
major_version_5=v5.x/
major_version_4=v4.x/
lname=linux-
extention=.tar.xz

read -p "Enter Version Number: " version

trimmed_version=$(echo $version | cut -c1)

if [[ $trimmed_version -eq 5 ]]; then
    wget -c $base_url$major_version_5$lname$version$extention
fi

if [[ $trimmed_version -eq 4 ]]; then
    wget -c $base_url$major_version_4$lname$version$extention
fi

