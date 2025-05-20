import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/json.{type DecodeError}
import gleam/list
import gleam/option.{type Option}
import gleam/pair
import outkeep/note.{type Note}

pub type NoteFile =
  #(String, Note)

pub type NoteFileDict =
  Dict(String, Note)

pub fn from_json(json_string: String) -> Result(NoteFile, DecodeError) {
  json.parse(from: json_string, using: {
    use filename <- decode.field("filename", decode.string)
    use content <- decode.field("content", note.decoder())

    decode.success(#(filename, content))
  })
}

pub fn filename(note_file: NoteFile) -> String {
  pair.first(note_file)
}

pub fn note(note_file: NoteFile) -> Note {
  pair.second(note_file)
}

pub fn map_note(note_file: NoteFile, by fun: fn(Note) -> a) -> a {
  note_file |> note |> fun
}

pub fn filter_map_note(
  note_files: List(NoteFile),
  by fun: fn(Note) -> Option(a),
) -> List(a) {
  note_files
  |> list.filter_map(fn(note_file) {
    note_file
    |> map_note(by: fun)
    |> option.to_result(Nil)
  })
}
