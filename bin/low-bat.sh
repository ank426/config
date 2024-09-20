while true; do
     bat=`acpi -b | grep -P -o '[0-9]+(?=%)' | head -n 1`
     if [ $bat -le 10 ]; then
         hyprctl notify 0 2000 0 " Battery Low"
     fi
     sleep 60
done
