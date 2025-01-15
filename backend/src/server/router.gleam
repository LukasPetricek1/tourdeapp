import gleam/http.{Get}
import gleam/json
import gleam/string_tree
import server/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> hello_world(req)
    ["api"] -> json_test(req)
    _ -> wisp.not_found()
  }
}

fn hello_world(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("<h1>Hello TdA!</h1>")
  wisp.ok()
  |> wisp.html_body(html)
}

fn json_test(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let body =
    json.object([#("organization", json.string("Student Cyber Games"))])
    |> json.to_string_tree

  wisp.ok()
  |> wisp.json_body(body)
}
