FROM alpine:latest as build
WORKDIR /build
RUN apk add --no-cache git \ 
                      automake \ 
                      make \
                      autoconf \
                      g++ \
                      libtool \
                      libxml2 \
                      libcurl \
                      pcre-dev \
                      linux-headers \
                      file \
                      curl \
                      zlib-dev && \
    git clone https://github.com/SpiderLabs/ModSecurity.git libmodsecurity && \
    cd libmodsecurity && \
    ./build.sh && \
    git submodule init && \
    git submodule update && \
    ./configure && \
    make && \
    make install

ARG NGINX_VERSION=1.16.1
RUN git clone https://github.com/SpiderLabs/ModSecurity-nginx.git modsecurity-nginx && \
    curl https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx.tar.gz && \
    tar xfz nginx.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --prefix=/etc/nginx \
                --add-module=/build/modsecurity-nginx && \
    make && \
    make install

FROM alpine:latest
COPY --from=build /usr/lib/ /usr/lib/
COPY --from=build /usr/local/modsecurity /usr/local/modsecurity
COPY --from=build /etc/nginx /etc/nginx

CMD ["/etc/nginx/sbin/nginx", "-g", "daemon off;"]