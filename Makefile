.PHONY: run

jcute.jar:
	sh package

liblpsolve55.so:
	cp /usr/lib/lp_solve/liblpsolve55.so .

liblpsolve55j.so:
	cp /usr/lib/lp_solve/liblpsolve55j.so .

run: liblpsolve55.so liblpsolve55j.so jcute.jar
	java -classpath jcute.jar:$(LIBRARIES) cute.Cute

test: liblpsolve55.so liblpsolve55j.so jcute.jar
	sh runtests

gui: liblpsolve55.so liblpsolve55j.so jcute.jar
	sh jcutegui
