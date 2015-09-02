# Compile .coffee-files from ./src and write them to ./lib 
lib:
	# Cleanup old files
	rm -f index.js
	rm -rf ./lib

	# Compile coffee and write to lib
	coffee --bare --output ./ --compile index.coffee
	coffee --output lib --compile src