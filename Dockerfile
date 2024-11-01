FROM ghcr.io/gleam-lang/gleam:v1.5.1-erlang-alpine

# Add project code
COPY ./backend /build/

# Compile the project
RUN cd /build \
  && gleam export erlang-shipment \
  && mv build/erlang-shipment /app \
  && rm -r /build

# Run the server
WORKDIR /app
ARG env_port
ENV PORT=$env_port
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
EXPOSE $env_port
