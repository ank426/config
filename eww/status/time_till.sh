#!/bin/sh

battery_dir=/sys/class/power_supply/BAT0

case $(cat $battery_dir/status) in
  Discharging)
    energy=$(cat $battery_dir/energy_now)
    power=$(cat $battery_dir/power_now)
    time=$(echo "$energy / $power" | bc -l)
    hours=$(echo "scale=0; $time/1" | bc -l)
    mins=$(echo "scale=0; 60 * ($time % 1) / 1" | bc -l)
    hum_pow=$(echo "scale=2; $power/1000000" | bc -l)
    echo "${hours}h ${mins}m till empty (${hum_pow} W)"
    ;;
  Charging)
    energy=$(cat $battery_dir/energy_now)
    energy_full=$(cat $battery_dir/energy_full)
    power=$(cat $battery_dir/power_now)
    time=$(echo "($energy_full - $energy) / $power" | bc -l)
    hours=$(echo "scale=0; $time/1" | bc -l)
    mins=$(echo "scale=0; 60 * ($time % 1) / 1" | bc -l)
    hum_pow=$(echo "scale=2; $power/1000000" | bc -l)
    echo "${hours}h ${mins}m till full (${hum_pow} W)"
    ;;
  'Not charging')
    echo 
    ;;
  *)
    cat $battery_dir/status
    ;;
esac
