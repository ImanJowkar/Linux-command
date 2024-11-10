FROM gcc AS BUILD
USER root
WORKDIR /app
COPY hello.c .
RUN gcc -o demo hello.c


FROM gcr.io/distroless/base-debian11
#FROM scratch
WORKDIR /app
COPY --from=BUILD /app/demo .
USER dev
CMD ["./demo"]