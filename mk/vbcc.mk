##
## VBCC XDK
##
.PHONY: install-vbcc
install-vbcc:
	make -C container/vbcc PREFIX=$(PREFIX) install

.PHONY: build-vbcc
build-vbcc:
	make -C container/vbcc PREFIX=$(PREFIX) all

.PHONY: clean-vbcc
clean-vbcc:
	make -C container/vbcc clean

##
## CONTAINERS
##
.PHONY: vbcc-xdk-container
vbcc-xdk-container:
	docker build \
		--file container/vbcc/Dockerfile \
		--build-arg IMAGE_TAG_PREFIX=$(IMAGE_TAG_PREFIX) \
		--tag $(IMAGE_TAG_PREFIX)/vbcc-xdk:latest \
		container/vbcc

.PHONY: push-vbcc-xdk-container
push-vbcc-xdk-container:
	docker push $(IMAGE_TAG_PREFIX)/vbcc-xdk:latest
