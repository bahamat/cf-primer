ifeq ($(shell uname), Darwin)
	bk = ''
endif

slides.html:
	pandoc -s -f markdown -t dzslides -o slides.html slides.md
	sed -i $(bk) 's/Arial/Helvetica, Arial/g' slides.html

clean:
	$(RM) slides.html*
