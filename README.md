# fluxcd-webui

Experimental Dockerimage for [FluxCD v2 webui](https://github.com/fluxcd/webui)

## Run the image

docker run -d -p 8080:1234 -v /local-path/.kube/config:/root/.kube/config adrianberger/fluxcd-webui
