
#!/bin/bash

# CPU Thermal Monitoring & BD PROCHOT Control
# Original platform: Intel Pentium N3540
# MSR: 0x1FC

TEMP_FILE="/sys/class/thermal/thermal_zone0/temp"

HIGH_TEMP=82000
LOW_TEMP=75000
INTERVAL=2

# true = locked
# false = unlocked
lock_state=true

# Load MSR kernel module
sudo modprobe msr || exit 1

echo "CPU Thermal Control started"

while true
do
    temperature=$(cat "$TEMP_FILE") || exit 1

    # Read current MSR value (hexadecimal)
    register=$(sudo rdmsr 0x1FC) || exit 1

    # Convert hexadecimal to integer
    register_value=$((16#$register))

    if (( temperature >= HIGH_TEMP )) && [[ "$lock_state" == false ]]
    then
        # Set bit 0: lock
        new_value=$((register_value | 1))

        sudo wrmsr 0x1FC "$new_value" || exit 1

        lock_state=true
        echo "Temperature: $temperature - CPU LOCKED"

    elif (( temperature <= LOW_TEMP )) && [[ "$lock_state" == true ]]
    then
        # Clear bit 0: unlock
        new_value=$((register_value & ~1))

        sudo wrmsr 0x1FC "$new_value" || exit 1

        lock_state=false
        echo "Temperature: $temperature - CPU UNLOCKED"

    fi

    sleep "$INTERVAL"
done
