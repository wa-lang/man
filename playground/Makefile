default:
	wabook serve

build:
	-rm -rf ../book/playground
	mkdir -p ../book/playground
	wabook build && mv ./book ./en && mv ./playground ../book/
	-rm ../book/playground/.gitignore

clean:
	-rm -rf book
