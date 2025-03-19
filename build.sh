#!/bin/bash

echo "Starting Kubernetes deployment..."
echo "=================================="

# Find all directories that contain YAML files
directories=$(find . -type f -name "*.yaml" -o -name "*.yml" | xargs dirname | sort | uniq)

# Loop through each directory and apply all YAML files
for dir in $directories; do
    echo -e "\nProcessing directory: $dir"
    echo "------------------------"
    
    # Find all YAML files in the directory
    yaml_files=$(find $dir -maxdepth 1 -type f -name "*.yaml" -o -name "*.yml")
    
    for file in $yaml_files; do
        echo "Applying: $file"
        kubectl apply -f $file
        
        # Check if the kubectl command was successful
        if [ $? -eq 0 ]; then
            echo "✅ Successfully applied $file"
        else
            echo "❌ Failed to apply $file"
        fi
    done
done

echo -e "\nDeployment process complete!"
echo "=================================="
