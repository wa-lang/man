default:
	wabook serve

build:
	-rm -rf ../book/en
	mkdir -p ../book/en
	wabook build && mv ./book ./en && mv ./en ../book/
	-rm ../book/en/.gitignore

clean:
	-rm -rf book
