find . -path \*/$1*
# Find, except interpret argument as a path "fragment", or partial path
#   For example, passing in "dir2/fi" would match the file path ./dir1/dir2/filename
# The reason the first "*" is backslash escaped is to prevent bash from expanding it
