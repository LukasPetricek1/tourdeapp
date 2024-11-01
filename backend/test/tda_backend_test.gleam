import gleam/string
import gleeunit
import gleeunit/should
import server/router
import wisp/testing

pub fn main() {
  gleeunit.main()
}

pub fn hello_world_test() {
  let response = router.handle_request(testing.get("/", []))

  response.status
  |> should.equal(200)

  response
  |> testing.string_body
  |> string.contains("Hello TdA")
  |> should.be_true
}

pub fn json_test() {
  let response = router.handle_request(testing.get("/api", []))

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "application/json; charset=utf-8")])

  response
  |> testing.string_body
  |> should.equal("{\"organization\":\"Student Cyber Games\"}")
}
