OUT = ag
PKG = github.com/arigatomachine/cli
SHA = $(shell git describe --always --long --dirty)
PKG_LIST = $(shell go list ${PKG}/... | grep -v /vendor/)
GO_FILES = $(shell find . -name '*.go' | grep -v /vendor/)
VERSION = $(shell git describe --tags --abbrev=0 | sed 's/^v//')

all: binary

binary:
	go build -i -v -o ${OUT} -ldflags="-X ${PKG}/config.Version=${VERSION}" ${PKG}

test:
	@go test -short $$(glide nv)

vet:
	@go vet ${PKG_LIST}

fmtcheck:
	@FMT=$$(for file in ${GO_FILES} ;  do \
		gofmt -l -s $$file ; \
	done) ; \
	if test -n "$$FMT"; then \
		echo "gofmt problems:" ; \
		echo "$$FMT" ; \
		exit 1 ; \
	fi ;

lint:
	@LINT=$$(for file in ${GO_FILES} ;  do \
		golint $$file ; \
	done) ; \
	if test -n "$$LINT"; then \
		echo "go lint problems:" ; \
		echo "$$LINT" ; \
		exit 1 ; \
	fi ;

static: vet fmtcheck lint
	go build -i -v -o ${OUT}-v${VERSION} -tags netgo -ldflags="-extldflags \"-static\" -w -s -X ${PKG}/config.Version=${VERSION}" ${PKG}

clean:
	-@rm ${OUT} ${OUT}-v*

.PHONY: run server static vet fmtcheck lint generated test
