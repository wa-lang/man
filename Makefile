# go install github.com/wa-lang/wabook@latest

default:
	wabook serve

build:
	-rm book
	wabook build
	make -C en build
	-rm book/.gitignore
	-rm -rf book/.git

deploy:
	-rm book
	wabook build
	make -C en build
	-rm book/.gitignore
	-rm -rf book/.git

	cd book && git init
	cd book && git add .
	cd book && git commit -m "first commit"
	cd book && git branch -M gh-pages
	cd book && git remote add origin git@github.com:wa-lang/man.git
	cd book && git push -f origin gh-pages

clean:
	-rm -rf book
