FROM alpine:latest

COPY hcd /bin
RUN apk --no-cache add curl jq && chmod 755 /bin/hcd

ENTRYPOINT [ "/bin/hcd" ]
