import gleam/json
import outkeep/note

pub fn note_from_json(json_string: String) {
  json_string |> json.parse(using: note.decoder())
}
