FROM alpine

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN chmod +x /app/hello
ENTRYPOINT /app/hello
