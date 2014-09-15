.PHONY: all
all: cf-primer.html

cf-primer.html: cf-primer.md policy_propagation.png
	pandoc --standalone --self-contained --from markdown --to slidy -o $@ $<

policy_propagation.png: policy_propagation.dot
	dot -Tpng -o $@ $<

clean:
	$(RM) cf-primer.html policy_propagation.png
