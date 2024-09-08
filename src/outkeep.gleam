import gleam/json
import outkeep/checklist
import outkeep/note
import outkeep/text_note

pub fn checklist_from_json(json_string: String) {
  json_string |> json.decode(using: checklist.decode)
}

pub fn text_note_from_json(json_string: String) {
  json_string |> json.decode(using: text_note.decode)
}

pub fn note_from_json(json_string: String) {
  json_string |> json.decode(using: note.decode)
}
