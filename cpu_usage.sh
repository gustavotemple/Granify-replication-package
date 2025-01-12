#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <duration in seconds> <container ID>"
  exit 1
fi

duration="$1"
container_id="$2"

if ! [[ "$duration" =~ ^[0-9]+$ ]]; then
  echo "Error: Duration must be a positive integer."
  exit 1
fi

echo "Measuring average CPU usage for container ID: $container_id"
echo "Duration: $duration seconds"

# Function to get average CPU usage for a given container ID
get_avg_cpu_usage() {
  docker stats --no-stream "$container_id" --format "{{.CPUPerc}}" | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }'
}

# Initial CPU usage value to calculate the delta later
prev_cpu_usage=$(get_avg_cpu_usage)

# Calculate the end time of the measurement
end_time=$((SECONDS + duration))

# Loop until the end time is reached
while [ $SECONDS -lt $end_time ]; do
  sleep 1
  curr_cpu_usage=$(get_avg_cpu_usage)
  
  # Calculate the difference in CPU usage between the two samples
  cpu_usage_diff=$(echo "$curr_cpu_usage - $prev_cpu_usage" | bc)
  
  prev_cpu_usage=$curr_cpu_usage
done

# Check if the final value is not zero before displaying
if (( $(echo "$cpu_usage_diff != 0" | bc -l) )); then
  # Output the final average CPU usage
  echo "Average CPU Usage after $duration seconds: $curr_cpu_usage%"
else
  echo "Warning: Average CPU usage was zero for the entire duration."
fi

