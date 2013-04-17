slides.html: slides.md
	pandoc --standalone --self-contained --from markdown --to slidy -o slides.html slides.md

clean:
	$(RM) slides.html*
