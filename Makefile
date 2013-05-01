slides.html: slides.md policy_propagation.png
	pandoc --standalone --self-contained --from markdown --to slidy -o $@ $<

policy_propagation.png: policy_propagation.dot
	dot -Tpng -o $@ $<

clean:
	$(RM) slides.html policy_propagation.png
