import db
import gleam/bit_array
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

pub fn uuid_test() {
  let uuid = db.uuid()

  string.length(uuid)
  |> should.equal(36)
}

pub fn game_test() {
  let game_string =
    "{\n  \"uuid\": \"67fda282-2bca-41ef-9caf-039cc5c8dd69\",\n  \"createdAt\": \"2025-01-17T15:36:51.493Z\",\n  \"updatedAt\": \"2025-01-17T15:36:51.493Z\",\n  \"name\": \"Moje první hra\",\n  \"difficulty\": \"hard\",\n  \"gameState\": \"midgame\",\n  \"board\": [\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"O\",\n      \"O\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"X\",\n      \"O\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"X\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"X\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ],\n    [\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\",\n      \"\"\n    ]\n  ]\n}"

  db.game_from_json(game_string)
  |> should.equal(
    Ok(db.Game(
      uuid: "67fda282-2bca-41ef-9caf-039cc5c8dd69",
      created_at: "2025-01-17T15:36:51.493Z",
      updated_at: "2025-01-17T15:36:51.493Z",
      name: "Moje první hra",
      difficulty: db.Hard,
      game_state: db.Midgame,
      board: db.Board(
        bit_array.pad_to_bytes(<<
          0:size(120), 0:size(8), 1:size(2), 1:size(2), 0:size(18), 0:size(10),
          2:size(2), 1:size(2), 0:size(16), 0:size(12), 2:size(2), 0:size(16),
          0:size(14), 2:size(2), 0:size(14), 0:size(210),
        >>),
      ),
    )),
  )
}
