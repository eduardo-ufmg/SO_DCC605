import sys
import re

# Function to extract readable strings from a binary file
def extract_strings(file_path, min_length=4):
    # Define a regex pattern for printable characters (ASCII)
    readable_char_pattern = re.compile(b'[\x20-\x7E]{' + str(min_length).encode() + b',}')

    # Open the image file in binary mode
    with open(file_path, 'rb') as f:
        # Read the content of the file
        data = f.read()

    # Search for readable strings
    matches = list(readable_char_pattern.finditer(data))
    
    # Print the strings and their starting position
    for match in matches:
        start_pos = match.start()
        string = match.group().decode('ascii', errors='ignore')  # Decode the bytes to ASCII string
        print(f"Found string: '{string}' at position: {start_pos}")

# Main function to accept file path as argument
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python extract_strings_from_image.py <image_file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    extract_strings(file_path)
