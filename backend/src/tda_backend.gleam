import db
import envoy
import gleam/erlang/process
import gleam/int
import gleam/io
import mist
import server/router
import sqlight
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let secret_key_base = case envoy.get("BACKEND_SECRET_KEY") {
    Ok(key) -> key
    Error(_) -> {
      io.println_error("No secret key found")
      wisp.random_string(64)
    }
  }

  let assert Ok(port) = case envoy.get("PORT") {
    Ok(port) -> int.parse(port)
    Error(_) -> Ok(8080)
  }

  let assert Ok(conn) = sqlight.open("file:./src/db.sqlite3")
  let context = db.Context(conn)
  let handler = router.handle_request(_, context)

  let assert Ok(_) =
    wisp_mist.handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(port)
    |> mist.bind("0.0.0.0")
    |> mist.start_http

  process.sleep_forever()
}
