# Compile .coffee-files from ./src and write them to ./lib 
lib:
	rm -rf ./lib
	coffee --output lib --compile src