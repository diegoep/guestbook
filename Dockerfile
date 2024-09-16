FROM golang:1.10.0
WORKDIR /app
ADD ./go.mod .
RUN go get github.com/urfave/negroni
RUN go get -u github.com/gorilla/mux
RUN go get -u github.com/xyproto/simpleredis/v2
ADD ./main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

FROM --platform=linux/amd64 scratch
WORKDIR /app
COPY --from=0 /app/main .
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css
COPY ./public/jquery.min.js public/jquery.min.js
CMD ["/app/main"]
EXPOSE 3000