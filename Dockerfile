FROM cgr.dev/chainguard/go:latest as build
ARG  OTEL_VERSION=0.119.0
WORKDIR /builder
ENV GOPATH=/usr
RUN go install go.opentelemetry.io/collector/cmd/builder@v${OTEL_VERSION}
COPY manifest.yaml .
RUN CGO_ENABLED=0 builder --config=/builder/manifest.yaml --output-path=/builder/otelcol-custom

FROM cgr.dev/chainguard/static:latest
COPY --from=build /builder/otelcol-custom /
EXPOSE 4317/tcp 4318/tcp 13133/tcp
CMD ["/otelcol-custom", "--config=/config.yaml" ]