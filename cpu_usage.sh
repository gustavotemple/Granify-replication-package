#!/bin/bash

# List all running containers
containers=($(docker ps --format "{{.ID}} {{.Names}}"))

# Check if there are running containers
if [ ${#containers[@]} -eq 0 ]; then
  echo "No running containers found."
  exit 1
fi

echo "Select a container to monitor:"
for ((i = 0; i < ${#containers[@]}; i+=2)); do
  index=$((i / 2))
  echo "[$index] ${containers[i+1]} (${containers[i]})"
done

# Prompt user to select a container
read -p "Enter the number of the container: " selection

container_index=$((selection * 2))
container_id="${containers[container_index]}"
container_name="${containers[container_index+1]}"

if [ -z "$container_id" ]; then
  echo "Invalid selection."
  exit 1
fi

# Prompt user for duration
read -p "Enter monitoring duration (in seconds): " duration

if ! [[ "$duration" =~ ^[0-9]+$ ]]; then
  echo "Error: Duration must be a positive integer."
  exit 1
fi

echo "Monitoring container: $container_name ($container_id)"
echo "Duration: $duration seconds"

# Initialize totals
total_cpu=0
total_mem=0
samples=0

# Function to get current CPU percentage
get_cpu_usage() {
  docker stats --no-stream "$container_id" --format "{{.CPUPerc}}" | tr -d '%'
}

# Function to get current memory usage in MiB
get_mem_usage() {
  docker stats --no-stream "$container_id" --format "{{.MemUsage}}" | awk -F'/' '{print $1}' | sed 's/[^0-9.]//g'
}

# Collect data over time
end_time=$((SECONDS + duration))
while [ $SECONDS -lt $end_time ]; do
  sleep 1
  cpu=$(get_cpu_usage)
  mem=$(get_mem_usage)

  total_cpu=$(echo "$total_cpu + $cpu" | bc)
  total_mem=$(echo "$total_mem + $mem" | bc)
  samples=$((samples + 1))
done

# Compute averages
avg_cpu=$(echo "scale=2; $total_cpu / $samples" | bc)
avg_mem=$(echo "scale=2; $total_mem / $samples" | bc)

# Output results
echo "---------------------------------------------"
echo "Average CPU Usage after $duration seconds: $avg_cpu%"
echo "Average Memory Usage after $duration seconds: $avg_mem MiB"

# Warnings
if (( $(echo "$avg_cpu == 0" | bc -l) )); then
  echo "Warning: Average CPU usage was zero."
fi

if (( $(echo "$avg_mem == 0" | bc -l) )); then
  echo "Warning: Average Memory usage was zero."
fi
