import extensions/should_
import gleam/dynamic.{DecodeError}
import gleam/json.{UnexpectedFormat}
import gleam/list
import gleam/result
import gleeunit
import gleeunit/should
import simplifile
import outkeep
import outkeep/checklist_item.{type ChecklistItem, ChecklistItem}
import outkeep/note

pub fn main() {
  gleeunit.main()
}

pub fn checklist_from_json_on_checklist_test() {
  let checklist =
    "./test/example_keep_checklist.json"
    |> read_file
    |> outkeep.checklist_from_json
    |> should.be_ok

  checklist.title |> should.equal("An example Keep checklist")

  checklist.is_archived |> should.be_false
  checklist.is_trashed |> should.be_false

  let assert [i1, i2, i3, i4] = checklist.items
  i1 |> item_should_have(is_checked: False, text: "I'm not checked")
  i1 |> item_should_have(is_checked: False, text: "I'm not checked")
  i2 |> item_should_have(is_checked: False, text: "I'm also not checked")
  i3 |> item_should_have(is_checked: True, text: "I'm checked")
  i4 |> item_should_have(is_checked: True, text: "I'm also checked")

  checklist.created_at |> should_.equal_iso8601("2024-08-12T03:32:12.334Z")
  checklist.edited_at |> should_.equal_iso8601("2024-08-12T04:48:16.020Z")
}

pub fn checklist_from_json_on_text_note_test() {
  "./test/example_keep_text_note.json"
  |> read_file
  |> outkeep.checklist_from_json
  |> should.be_error
  |> should.equal(
    UnexpectedFormat([
      DecodeError(expected: "field", found: "nothing", path: ["listContent"]),
    ]),
  )
}

pub fn text_note_from_json_on_text_note_test() {
  let text_note =
    "./test/example_keep_text_note.json"
    |> read_file
    |> outkeep.text_note_from_json
    |> should.be_ok

  text_note.title |> should.equal("An example Keep text note")
  text_note.is_archived |> should.be_true
  text_note.is_trashed |> should.be_false

  text_note.text
  |> should.equal("Here is some text" <> "\n" <> "that is on multiple lines")

  text_note.created_at |> should_.equal_iso8601("2024-01-09T18:51:17.418Z")
  text_note.edited_at |> should_.equal_iso8601("2024-01-09T19:53:46.609Z")
}

pub fn text_note_from_json_on_checklist_test() {
  "./test/example_keep_checklist.json"
  |> read_file
  |> outkeep.text_note_from_json
  |> should.be_error
  |> should.equal(
    UnexpectedFormat([
      DecodeError(expected: "field", found: "nothing", path: ["textContent"]),
    ]),
  )
}

pub fn note_from_json_test() {
  let assert [n_checklist, n_text] =
    ["./test/example_keep_checklist.json", "./test/example_keep_text_note.json"]
    |> list.map(fn(fpath) { fpath |> read_file |> outkeep.note_from_json })
    |> result.all
    |> should.be_ok

  n_checklist |> note.title |> should.equal("An example Keep checklist")
  n_checklist |> note.is_archived |> should.be_false
  n_checklist |> note.is_trashed |> should.be_false
  n_checklist
  |> note.created_at
  |> should_.equal_iso8601("2024-08-12T03:32:12.334Z")
  n_checklist
  |> note.edited_at
  |> should_.equal_iso8601("2024-08-12T04:48:16.020Z")

  n_text |> note.title |> should.equal("An example Keep text note")
  n_text |> note.is_archived |> should.be_true
  n_text |> note.is_trashed |> should.be_false
  n_text |> note.created_at |> should_.equal_iso8601("2024-01-09T18:51:17.418Z")
  n_text |> note.edited_at |> should_.equal_iso8601("2024-01-09T19:53:46.609Z")
}

// --- Helpers and such

fn read_file(filepath: String) -> String {
  let assert Ok(content) = simplifile.read(from: filepath)
  content
}

fn item_should_have(
  item item: ChecklistItem,
  is_checked is_checked: Bool,
  text text: String,
) {
  item |> should.equal(ChecklistItem(is_checked:, text:))
}
