SASSC=sassc
RACKET=racket
HTML2PDF=wkhtmltopdf
HTML2IMG=wkhtmltoimage

STYLES=$(wildcard src/*.sass)
RESUMES=$(wildcard src/resume*.rkt)

HTML=${RESUMES:src/%.rkt=build/%.html} build/cover.html
PDF=${HTML:build/%.html=%.pdf}
JPG=${PDF:%.pdf=build/%.jpg}
CSS=${STYLES:src/%.sass=build/%.css}


all: ${CSS} ${HTML} ${PDF} ${JPG}

clean:
	rm -rf build ${PDF}

c: clean

.PHONY: all clean c

build/%.css: src/%.sass
	@mkdir -p build
	${SASSC} $< $@

build/resume.html: src/resume.rkt resume-gen.rkt ${CSS}
	@mkdir -p build
	${RACKET} $< > $@

build/cover.html: src/cover.html ${CSS}
	@mkdir -p build
	cp $< $@

%.pdf: build/%.html
	${HTML2PDF} -s Letter \
		-B 0mm -L 0mm -R 0mm -T 0mm \
		$< $@

build/%.jpg: build/%.html
	${HTML2IMG} $< $@
