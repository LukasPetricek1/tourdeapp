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
ENV PORT=4000
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
EXPOSE 4000
