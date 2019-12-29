SASSC=sassc
RACKET=racket
HTML2PDF=wkhtmltopdf
HTML2IMG=wkhtmltoimage

STYLES=$(wildcard src/*.sass)
RESUMES=$(wildcard src/resume*.rkt)

PDF=${RESUMES:src/%.rkt=%.pdf}
JPG=${RESUMES:src/%.rkt=build/%.jpg}
CSS=${STYLES:src/%.sass=build/%.css}
HTML=${RESUMES:src/%.rkt=build/%.html}


all: ${CSS} ${HTML} ${PDF} ${JPG}

clean:
	rm -rf build ${PDF}

c: clean

.PHONY: all clean c

build/%.css: src/%.sass
	@mkdir -p build
	${SASSC} $< $@

build/%.html: src/%.rkt resume-gen.rkt ${CSS}
	@mkdir -p build
	${RACKET} $< > $@

%.pdf: build/%.html
	${HTML2PDF} -s Letter \
		-B 0mm -L 0mm -R 0mm -T 0mm \
		$< $@

build/%.jpg: build/%.html
	${HTML2IMG} $< $@
