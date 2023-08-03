# MM2K Poster Border Script

This is a Bash script that uses ImageMagick to replace the standard white boarder on MM2K posters with a boarder colour of your choice. The border color can be customized using a HEX color code. The script allows you to specify an input folder containing images, an output folder to save processed images, and optionally the border color in HEX format. You can also enable the script to overwrite existing files in the output folder using the `-x` flag.

## Prerequisites

- ImageMagick: Make sure you have ImageMagick installed on your system. If not, you can install it using the package manager for your OS.

## Usage

```bash
./change_boarder.sh -i input_folder_path -o output_folder_path [-c "border_color"] [-x]
```

## Options
* -i input_folder_path: Specify the input folder containing images to process.
* -o output_folder_path: Specify the output folder where processed images will be saved.
* -c "border_color" (Optional): Specify the border color in HEX format within double quotes. If not provided, the default border color is black (#000000).
* -x (Optional): Enable overwriting existing files in the output directory. If this flag is not specified, the script will skip processing existing files.

## Notes
* The script supports JPEG and PNG images only.
* If the output folder does not exist, the script will create it.
* If a file with the same name already exists in the output folder, the script will either skip processing or overwrite it based on the -x flag.
