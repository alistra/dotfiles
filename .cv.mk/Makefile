all: cv.tex urlcheck
	rubber -d cv.tex
	rm -f cv.aux cv.out cv.log

long: cv-long.tex
	rubber -d cv-long.tex
	rm -rf cv-long.aux cv-long.out cv-long.log

urlcheck:
	./urlcheck.py cv.tex
