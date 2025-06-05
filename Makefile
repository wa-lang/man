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

to-word:
	-rm book

	mkdir -p book

	cp -r chs/2.*/images book/

	cat chs/1.*/readme.md                > book/ch1-tmp.md
	cat chs/2.*/readme.md chs/2.*/?.*.md > book/ch2-tmp.md
	cat chs/3.*/readme.md chs/3.*/?.*.md > book/ch3-tmp.md
	cat chs/4.*/readme.md chs/4.*/?.*.md > book/ch4-tmp.md
	cat chs/5.*/readme.md chs/5.*/?.*.md > book/ch5-tmp.md
	cat chs/6.*/readme.md chs/6.*/?.*.md > book/ch6-tmp.md
	cat chs/7.*/readme.md chs/7.*/?.*.md > book/ch7-tmp.md
	cat chs/8.*/readme.md chs/8.*/?.*.md > book/ch8-tmp.md
	cat chs/9.*/readme.md chs/9.*/?-*.md > book/ch9-tmp.md

	cat book/ch*-tmp.md > book/doc-chx-tmp.md

	pandoc -s --toc --toc-depth=2 book/doc-chx-tmp.md -o book/doc-toc-tmp.md
	cat \
		book/doc-chx-tmp.md \
	> book/doc-all-tmp.md

	cd book && pandoc -f markdown -t docx doc-all-tmp.md -o wa-man.docx


clean:
	-rm -rf book
