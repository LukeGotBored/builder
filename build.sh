#!/bin/bash

# Declare variables for terminal text formatting
bold=$(tput bold)
yellow=$(tput setaf 3)
normal=$(tput sgr0)
newline=$'\n'

version="1.2"

# Show the help message if the -help, --help, or -h flag is present
if [ "$1" == "-help" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "${bold}${yellow}C project build script | version ${version}${normal}${newline}"
    echo "Usage: build.sh [-o executable_name] [-r] [-f] [-help]"
    echo "  ${bold}-o executable_name${normal}: use the specified name as the name of the executable file"
    echo "  ${bold}-r${normal}: run the project after building it"
    echo "  ${bold}-f${normal}: force the build, do not ask for confirmation if there are files in the ${bold}build${normal} folder"
    echo "  ${bold}-clang${normal}: use clang compiler instead of gcc"
    echo "  ${bold}-help${normal}, ${bold}--help${normal}, ${bold}-h${normal}: show this message${newline}"
    exit 0
fi

# Use the specified name as the output file if the -o flag is present, otherwise use the default name
if [[ "$@" == *"-o"* ]]; then
    # Get the value after the -o flag and remove -o from it. There can be a space after -o but it's optional, the filename won't have spaces at the beginning or end
    output_file=$(echo "$@" | sed -E 's/.*-o ?//g' | sed -E 's/ .*//g')
else
    output_file="main"
fi

# Set the force_build variable to true if the -f flag is present, otherwise set it to false
force_build=false
if [[ "$@" == *"-f"* ]]; then
    force_build=true
fi

# If there are files in the build folder and the -f flag is not present, warn the user and ask for confirmation before continuing
if [ "$(ls -A build)" ] && [ "$force_build" == "false" ]; then
    read -p "${yellow}[!] There are already files in the ${bold}build${normal}${yellow} folder, if you continue all the files inside will be deleted. Continue? [y/N] ${normal}" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "[*] Cancelled."
        exit 0
    fi
fi

# Set the run_after_build variable to true if the -r flag is present, otherwise set it to false
run_after_build=false
if [[ "$@" == *"-r"* ]]; then
    run_after_build=true
fi

# Create the build folder if it doesn't exist, and remove all files inside it
mkdir -p build
rm -rf build/*

# Go to the build folder
cd build

# Create the bin folder inside the build folder
mkdir -p bin
cd bin


# Compile the project
echo "[*] Building project..."

if [[ "$@" == *"-clang"* ]]; then
    echo "[*] Using clang compiler"
    # check if clang is installed
    if ! command -v clang &> /dev/null
    then
        echo "${red}[!] clang could not be found, please install it and try again${normal}"
        exit
    fi

    clang -c ../../*.c -Wall -Wextra -Wpedantic -Werror=shadow -Werror=implicit-function-declaration -Wno-unused -std=c11 -fsanitize=memory,undefined -g
    clang -o ${output_file} *.o -Wall -Wextra -Wpedantic -Werror=shadow -Werror=implicit-function-declaration -Wno-unused -std=c11 -fsanitize=memory,undefined -g

else
    echo "[*] Using gcc compiler"
    # check if gcc is installed
    if ! command -v gcc &> /dev/null
    then
        echo "${red}[!] gcc could not be found, please install it and try again${normal}"
        exit
    fi
    gcc -c ../../*.c -Wall -Wextra -std=c11
    gcc -o ${output_file} *.o -Wall -Wextra -std=c11
fi

# Move the executable to the root of the build folder
mv ${output_file} ../
cd ..

# If the -r flag is present, run the project
if [ "$run_after_build" == "true" ]; then
    echo "[*] Running project..."
    ./${output_file}
fi

echo "[*] Build complete."