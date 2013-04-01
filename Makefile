slides.html:
	pandoc -s -f markdown -t dzslides -o slides.html slides.md

clean:
	rm -f slides.html
