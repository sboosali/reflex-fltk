##################################################
##################################################
all: build

####################
.PHONY:	all check configure build clean docs update rebuild

##################################################
##################################################
configure:
	cabal --enable-nix new-configure --project-file ./cabal.project

####################
check:
	cabal new-build -fno-code -O0 all

####################
compile:
	cabal new-build all

####################
repl:
	cabal new-repl reflex-fltk

# ####################
# install:
# 	cabal new-build all

####################
rebuild: clean update configure build docs

####################
clean:
	rm -rf dist/ dist-newstyle/ .sboo/
	rm -f *.project.local .ghc.environment.*

##################################################
##################################################
build: check compile

####################
tags: compile
	mkdir -p .sboo/
	fast-tags -o ".sboo/tags" -R .
	cat ".sboo/tags"

####################
update:
	cabal new-update

####################
watch:
	@exec ./scripts/watch.sh &

##################################################
##################################################

########################
build-docs: compile
	cabal new-haddock all
# 	cp -aRv dist-newstyle/build/*/*/unpacked-containers-0/doc/html/unpacked-containers/* docs
# 	cd docs && git commit -a -m "update haddocks" && git push && cd ..

########################
copy-docs: build-docs
	rm -fr ".sboo/documentation/"
	mkdir -p ".sboo/documentation/"
	cp -aRv  ./dist-newstyle/build/*-*/ghc-*/reflex-fltk-*/noopt/doc/html/reflex-fltk/* ".sboo/documentation/"

########################
open-docs:
	xdg-open ".sboo/documentation/index.html"

########################
docs: build-docs copy-docs open-docs

##################################################
##################################################

####################
sdist:
	cabal check
	cabal sdist

####################
release: sdist
	mkdir -p "release/"
	cp "dist/reflex-fltk-*.tar.gz" "release/"
        #TODO `VERSION` Makefile variable.
        #TODO `cabal new-sdist`?

# e.g.
#    dist/reflex-fltk-0.0.tar.gz

##################################################
##################################################