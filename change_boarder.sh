#!/bin/bash

# Default border color to black
border_color="#000000"

# Default overwrite option to false
overwrite=false

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick not found. Please install it before running this script."
    exit 1
fi

# Function to print the script usage
print_usage() {
    echo "Usage: $0 -i input_folder_path -o output_folder_path [-c \"border_color\"] [-x]"
    echo ""
    echo "Options:"
    echo "  -i input_folder_path   Specify the input folder containing images to process."
    echo "  -o output_folder_path  Specify the output folder where processed images will be saved."
    echo "  -c \"border_color\"      Optional. Specify the border color in HEX format within double quotes."
    echo "                         If not provided, the default border color is black (#000000)."
    echo "  -x                     Optional. Enable overwriting existing files in the output directory."
    echo "                         If this flag is not specified, the script will skip processing existing files."
    echo ""
    echo "Example usage:"
    echo "  Process images in '/path/to/input_folder', add a red border, and save the processed images to '/path/to/output_folder':"
    echo "  $0 -i /path/to/input_folder -o /path/to/output_folder -c \"#FF0000\""
    echo ""
    echo "  Process images in '/path/to/input_folder', add a black border, and save the processed images to '/path/to/output_folder':"
    echo "  $0 -i /path/to/input_folder -o /path/to/output_folder"
    echo ""
    echo "  Process images in '/path/to/input_folder', add a red border, overwrite existing files in '/path/to/output_folder':"
    echo "  $0 -i /path/to/input_folder -o /path/to/output_folder -c \"#FF0000\" -x"
}

# Function to check if a file exists in the output folder
file_exists() {
    local filename="$1"
    if [ -e "$output_folder/$filename" ]; then
        return 0
    else
        return 1
    fi
}

# Parse command-line arguments
while getopts "i:o:c:x" opt; do
    case "$opt" in
        i) input_folder="$OPTARG";;
        o) output_folder="$OPTARG";;
        c) border_color="$OPTARG";;
        x) overwrite=true;;
        *) print_usage
           exit 1;;
    esac
done

# Check if required arguments are provided
if [ -z "$input_folder" ] || [ -z "$output_folder" ]; then
    print_usage
    exit 1
fi

# Check if the input folder exists
if [ ! -d "$input_folder" ]; then
    echo "Input folder not found."
    exit 1
fi

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Get the list of all image files in the folder (JPEG and PNG only for simplicity)
find "$input_folder" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png \) | while IFS= read -r input_file; do
    # Get the file name without the path and the file extension
    file_name=$(basename -- "$input_file")
    file_extension="${file_name##*.}"
    file_name="${file_name%.*}"

    # Check if the file already exists in the output folder
    if file_exists "$file_name.$file_extension"; then
        if [ "$overwrite" = true ]; then
            echo "Overwriting existing file: $file_name.$file_extension"
            rm "$output_folder/$file_name.$file_extension"
        else
            echo "File already exists in the output folder. Skipping processing: $file_name.$file_extension"
            continue
        fi
    fi

    # Perform the cropping operation using ImageMagick
    convert "$input_file" -gravity center -crop "$(identify -format "%[fx:w-50]x%[fx:h-50]+0+0" "$input_file")" +repage "$output_folder/$file_name.$file_extension"

    # Add a 25px border with the specified color to the cropped image
    convert "$output_folder/$file_name.$file_extension" -bordercolor "$border_color" -border 25 "$output_folder/$file_name.$file_extension"

    echo "Cropping and adding border with color $border_color complete. Cropped and bordered image saved as: $output_folder/$file_name.$file_extension"
done
