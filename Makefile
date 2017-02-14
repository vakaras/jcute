DOCKER_IMAGE_VERSION=0.0.1
DOCKER_IMAGE_NAME=vakaras/jcute:$(DOCKER_IMAGE_VERSION)

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

build_container:
	sudo docker build -t $(DOCKER_IMAGE_NAME) .

workspace:
	mkdir -p workspace

run_container: workspace
	sudo docker run --rm -ti \
		-e DISPLAY=${DISPLAY} \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v "$(CURDIR)/workspace:/home/developer" \
		-v "$(CURDIR):/home/developer/jcute/" \
		$(DOCKER_IMAGE_NAME) /usr/bin/fish
