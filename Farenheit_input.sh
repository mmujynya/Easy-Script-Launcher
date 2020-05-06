### Conversion F to Celsius ###
# Read input into variable
# ----------------------------------------
echo "Please enter a temp in Farenheit:"
read anothertemp
new_value=$((10#$anothertemp))
temp_a1=$(echo "scale=2; $new_value - 32" | bc)
temp_a2=$(echo "scale=2; $temp_a1 * 5 / 9" | bc)
echo "Temperature in Celsius:" $temp_a2
