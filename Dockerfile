FROM node:14-alpine AS builder

# in order to get go to run properly, whe need this symlink
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# environment variables
ENV GOPATH /root/go
ENV PATH /usr/local/kubebuilder/bin:$GOPATH/bin:/usr/local/go/bin:$PATH

WORKDIR /usr/src/app/webui

# install tools
RUN apk add --no-cache git curl make

# download & install go
RUN wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz &&\
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz &&\
rm go1.16.2.linux-amd64.tar.gz

# get gin
RUN go get github.com/codegangsta/gin

# download & install kubebuiler
RUN curl -L https://go.kubebuilder.io/dl/2.3.1/$(go env GOOS)/$(go env GOARCH) | tar -xz -C /tmp/ &&\
mv /tmp/kubebuilder_2.3.1_$(go env GOOS)_$(go env GOARCH) /usr/local/kubebuilder

RUN git clone https://github.com/fluxcd/webui.git .

RUN mkdir dist

RUN npm install --silent &&\
go build -o backend

## Add kubeconfig somehow

FROM node:14-alpine

# in order to get go to run properly, whe need this symlink
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

WORKDIR /usr/src/app/webui

COPY --from=builder /usr/src/app/webui/ /usr/src/app/webui
COPY process_wrapper.sh /usr/src/app/webui
RUN chmod u+x /usr/src/app/webui/process_wrapper.sh &&\
sed -i 's/localhost:3000/localhost:9000/g' /usr/src/app/webui/dev-server.js

EXPOSE 1234
CMD [ "/usr/src/app/webui/process_wrapper.sh" ]