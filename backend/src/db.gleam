import gleam/bit_array
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/string
import sqlight

pub type Context {
  Context(conn: sqlight.Connection)
}

pub type Game {
  Game(
    uuid: String,
    created_at: String,
    updated_at: String,
    name: String,
    difficulty: Difficulty,
    game_state: GameState,
    board: Board,
  )
}

pub type Difficulty {
  Beginner
  Easy
  Medium
  Hard
  Extreme
}

pub type GameState {
  Opening
  Midgame
  Endgame
  Unknown
}

pub type Board {
  Board(BitArray)
}

@external(erlang, "uuid", "get_v4")
pub fn uuid_erl() -> BitArray

pub fn uuid() -> String {
  let uuid = uuid_erl() |> bit_array.base16_encode
  string.slice(uuid, 0, 8)
  <> "-"
  <> string.slice(uuid, 8, 4)
  <> "-"
  <> string.slice(uuid, 12, 4)
  <> "-"
  <> string.slice(uuid, 16, 4)
  <> "-"
  <> string.slice(uuid, 20, 12)
}

pub fn difficulty_decoder() {
  use decoded_string <- decode.then(decode.string)
  case string.lowercase(decoded_string) {
    "beginner" -> decode.success(Beginner)
    "easy" -> decode.success(Easy)
    "medium" -> decode.success(Medium)
    "hard" -> decode.success(Hard)
    "extreme" -> decode.success(Extreme)
    _ -> decode.failure(Beginner, "Difficulty")
  }
}

pub fn game_state_decoder() {
  use decoded_string <- decode.then(decode.string)
  case string.lowercase(decoded_string) {
    "opening" -> decode.success(Opening)
    "midgame" -> decode.success(Midgame)
    "endgame" -> decode.success(Endgame)
    _ -> decode.failure(Unknown, "GameState")
  }
}

pub fn board_from_list(board_list: List(List(String))) -> Result(Board, Nil) {
  let flat_list = list.flatten(board_list)
  let bits = {
    use bits, symbol <- list.fold_until(flat_list, <<>>)
    case string.uppercase(symbol) {
      "" -> list.Continue(bits |> bit_array.append(<<0:size(2)>>))
      "O" -> list.Continue(bits |> bit_array.append(<<1:size(2)>>))
      "X" -> list.Continue(bits |> bit_array.append(<<2:size(2)>>))
      _ -> list.Stop(<<>>)
    }
  }
  case bit_array.bit_size(bits) == 15 * 15 * 2 {
    True -> Ok(Board(bit_array.pad_to_bytes(bits)))
    False -> Error(Nil)
  }
}

pub fn game_from_json(json_string: String) {
  let game_decoder = {
    use uuid <- decode.field("uuid", decode.string)
    use created_at <- decode.field("createdAt", decode.string)
    use updated_at <- decode.field("updatedAt", decode.string)
    use name <- decode.field("name", decode.string)
    use difficulty <- decode.field("difficulty", difficulty_decoder())
    use game_state <- decode.field("gameState", game_state_decoder())
    use board_list <- decode.field(
      "board",
      decode.list(decode.list(decode.string)),
    )
    case board_list |> board_from_list {
      Ok(board) -> {
        decode.success(Game(
          uuid:,
          created_at:,
          updated_at:,
          name:,
          difficulty:,
          game_state:,
          board:,
        ))
      }
      Error(_) -> {
        decode.failure(
          Game(
            uuid:,
            created_at:,
            updated_at:,
            name:,
            difficulty:,
            game_state:,
            board: Board(<<>>),
          ),
          "Game",
        )
      }
    }
  }
  json.parse(json_string, game_decoder)
}
