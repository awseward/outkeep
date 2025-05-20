import birl
import cake
import cake/dialect/sqlite_dialect
import cake/insert as i
import cake/param.{BoolParam, FloatParam, IntParam, NullParam, StringParam}
import gleam/dict
import gleam/dynamic/decode
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleam/yielder
import outkeep/export/note_file.{type NoteFileDict}
import outkeep/note
import sqlight.{type Connection}
import stdin

// gleam run -m outkeep/unstable
pub fn main() {
  use note_files <- result.try(read_all_note_files_from_stdin())
  use conn <- sqlight.with_connection("build/test.db")
  setup_db(on: conn)
  note_files
  |> list.sized_chunk(into: 5)
  |> list.map(dict.from_list)
  |> list.each(insert_note_files(_, on: conn))

  note_files
  |> spread(by: note_file.map_note(_, note.color))
  |> echo

  Ok(Nil)
}

fn setup_db(on conn: Connection) -> Nil {
  let _ =
    "
CREATE TABLE IF NOT EXISTS note_files(
  filename   TEXT NOT NULL UNIQUE
, title      TEXT
, color      TEXT NOT NULL
, created_at TEXT NOT NULL
, edited_at  TEXT NOT NULL
);"
    |> echo
    |> sqlight.exec(on: conn)
  Nil
}

fn insert_note_files(note_files: NoteFileDict, on conn: Connection) {
  let prepared_statement =
    note_files
    |> build_insert_query
    |> sqlite_dialect.write_query_to_prepared_statement
  let params =
    prepared_statement
    |> cake.get_params
    |> list.map(fn(param) {
      case param {
        BoolParam(param) -> sqlight.bool(param)
        FloatParam(param) -> sqlight.float(param)
        IntParam(param) -> sqlight.int(param)
        StringParam(param) -> sqlight.text(param)
        NullParam -> sqlight.null()
      }
    })

  prepared_statement
  |> cake.get_sql
  |> echo
  |> sqlight.query(on: conn, with: params, expecting: decode.dynamic)
  |> echo_error
}

fn echo_error(r: Result(a, e)) {
  result.map_error(r, fn(e) { echo e })
}

// SELECT created_at, color, coalesce(title, filename) FROM note_files ORDER BY created_at ASC;
// SELECT color, count(*) FROM note_files GROUP BY 1 ORDER BY 2 DESC;
// SELECT * FROM note_files WHERE title IS NULL;

fn build_insert_query(note_files: NoteFileDict) {
  let columns = ["filename", "title", "color", "created_at", "edited_at"]

  note_files
  |> dict.map_values(fn(filename, note) {
    [
      i.string(filename),
      case note |> note.title {
        None -> i.null()
        Some("") -> i.null()
        Some(title) -> i.string(title)
      },
      i.string(note |> note.color |> string.inspect),
      i.string(note |> note.created_at |> birl.to_iso8601),
      i.string(note |> note.edited_at |> birl.to_iso8601),
    ]
    |> i.row
  })
  |> dict.values
  |> i.from_values(table_name: "note_files", columns:)
  |> i.returning(columns)
  |> i.to_query
}

fn read_all_note_files_from_stdin() {
  stdin.read_lines()
  |> yielder.to_list
  |> list.map(note_file.from_json)
  |> result.all
  |> result.replace_error(Nil)
}

fn spread(xs: List(a), by fun: fn(a) -> b) {
  let length_f = fn(xs) { xs |> list.length |> int.to_float }
  let total_count = length_f(xs)

  xs
  |> list.group(by: fun)
  |> dict.map_values(fn(_key, group) {
    let assert Ok(v) =
      group
      |> length_f
      |> float.divide(by: total_count)
      |> result.map(float.to_precision(_, 4))

    v
  })
}
