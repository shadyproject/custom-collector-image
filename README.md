# Creating a custom collector

This repo shows an example of how to create a custom collector using the OpenTelemtry Collector Builder.

The OpenTelemetry Collector builder is the recommended approach for deploying collectors to production environments to ensure that you only include components that you need and therefore reduce the risk of security issues.

## `Manifest.yaml`

The `manifest.yaml` is where you configure the individual components you need to be included. This is different to your `config.yaml` for the collector. This file references the components' source code in github (or the go package repository), and also the version that you need.

### Example

```yaml
exporters:
  - gomod: ... v0.119.0
processors:
  - gomod: ... v0.119.0
receivers:
  - gomod: ... v0.119.0
extensions:
  - gomod: ... v0.119.0
connectors:
  - gomod: ... v0.119.0
```

## Non-OpenTelemetry managed components

You can use the OpenTelemetry Collector Builder to bring in components that are not managed by the OpenTelemetry Collector Maintainers.

The respository must have a tag for the component in the format `{componentname}/v{version}` for it to be pulled in.

Here's an example of a repo that has the correct format

```yaml
processors:
  - gomod: github.com/puckpuck/opentelemetry-collector-extras/metricsasattributesprocessor v0.4.0
```

## Building

To build the image, it's a two stage process and you don't need go installed locally to do it.

```shell
docker build . -t local/collector-custom
```

## Testing

My recommendation for testing is to run the container and access the healthcheck endpoint

```shell
docker run -v $(pwd)/test-config.yaml:/config.yaml -p 13133:13133 local/collector-custom
curl -s http://localhost:13133/ | jq
```

This should return a response that looks something like:

```json
{
  "status": "Server available",
  "upSince": "2025-02-14T16:17:13.537178212Z",
  "uptime": "10.567232955s"
}
```

## Deployment

You can now push the image using whatever mechanism you use for Azure Container Registry, DockerHub, AWS Container Registry.

You will need to mount your config file to `/config.yaml` in the container.

## Images

This Dockerfile use the Chainguard secured images. The Go container and runtime container are managed by Chainguard. The `static` image includes the latest certificates available, you should regularly rebuild containers to ensure you're getting the latest certificate revocations.
