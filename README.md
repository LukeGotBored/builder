# builder.sh
Welcome to the `builder.sh` project!

## Overview

`builder.sh` is a shell script that allows you to easily build and run C projects. It has a number of options to customize the build process, including specifying the name of the executable, running the project after building it, and forcing the build without confirmation. It also supports using the Clang compiler instead of GCC.

## Usage

To use `builder.sh`, simply navigate to the root directory of your C project and run the script with the desired options:

```bash
./build.sh [-o executable_name] [-r] [-f] [-clang] [-help]
```

### Options

- `-o executable_name`: Use the specified name as the name of the executable file.
- `-r`: Run the project after building it.
- `-f`: Force the build, do not ask for confirmation if there are files in the `build` folder.
- `-clang`: Use Clang compiler instead of GCC.
- `-help`, `--help`, `-h`: Show the usage message.

## Examples

Here are a few examples of how you might use `builder.sh`:

Build and run the project with the default executable name:
```bash
./build.sh -r
```

Build the project with the Clang compiler and a custom executable name:
```bash
./build.sh -o my_project -clang
```

Force the build and use the default executable name:
```bash
./build.sh -f
```

## Contributing

If you have suggestions for improvements or bug fixes for `builder.sh`, please feel free to open a pull request or issue on the [GitHub repository](https://github.com/LukeGotBored/builder). We welcome all contributions!
