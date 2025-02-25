ARG VERSION=v3.5.6
FROM quay.io/coreos/etcd:${VERSION}

# Copy MinIO client (mc) binary to the container
COPY --chmod=0766 mc /usr/bin/

# Install necessary certificates
RUN apt-get update \
    && apt-get install -y ca-certificates \
    && update-ca-certificates

# Copy the entrypoint script and set executable permissions
COPY --chmod=0766 entrypoint.sh /opt/entrypoint.sh

# Define the entrypoint for the container
ENTRYPOINT ["bash", "/opt/entrypoint.sh"]
