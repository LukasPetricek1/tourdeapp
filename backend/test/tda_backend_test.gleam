import db
import gleam/string
import gleeunit
import gleeunit/should
import server/router
import simplifile
import sqlight
import wisp/testing

const test_db = "file:./src/test.sqlite3"

pub fn main() {
  let assert Ok(Nil) = {
    use conn <- sqlight.with_connection(test_db)
    let sql = "DROP TABLE games;"
    let _ = sqlight.exec(sql, conn)
    let assert Ok(sql) = simplifile.read("./sql/create.sql")
    sqlight.exec(sql, conn)
  }
  gleeunit.main()
}

pub fn hello_world_test() {
  let assert Ok(conn) = sqlight.open(test_db)
  let context = db.Context(conn)

  let response = router.handle_request(testing.get("/", []), context)

  response.status
  |> should.equal(200)

  response
  |> testing.string_body
  |> string.contains("Hello TdA")
  |> should.be_true
}

pub fn json_test() {
  let assert Ok(conn) = sqlight.open(test_db)
  let context = db.Context(conn)

  let response = router.handle_request(testing.get("/api", []), context)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "application/json; charset=utf-8")])

  response
  |> testing.string_body
  |> should.equal("{\"organization\":\"Student Cyber Games\"}")
}
