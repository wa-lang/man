default:
	mdbook serve

build:
	-rm ../book/en
	mkdir -p ../book/en
	mdbook build -d ../book/en
	-rm ../book/en/.gitignore

clean:
	-rm -rf book
