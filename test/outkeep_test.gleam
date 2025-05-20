import extensions/should_
import gleam/json
import gleam/option.{None, Some}
import gleam/string
import gleam/uri.{Uri}
import gleeunit
import gleeunit/should
import outkeep
import outkeep/annotation.{type Annotation, Annotation, Weblink}
import outkeep/checklist_item.{ChecklistItem}
import outkeep/color.{type Color}
import outkeep/note.{type Note}
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn note_from_json_with_checklist_test() {
  let note =
    "./test/example_keep_checklist.json"
    |> expect_note_from_file
    |> should_match_note(
      title: "An example Keep checklist",
      is_archived: False,
      is_trashed: False,
      created_at: "2024-08-12T03:32:12.334Z",
      edited_at: "2024-08-12T04:48:16.020Z",
      color: color.Default,
      annotations: [],
    )

  note
  |> note.items
  |> should.be_ok
  |> should.equal([
    ChecklistItem(
      is_checked: False,
      text: "I'm not checked",
      text_html: "<!-- … snipped for brevity … -->",
    ),
    ChecklistItem(
      is_checked: False,
      text: "I'm also not checked",
      text_html: "<!-- … snipped for brevity … -->",
    ),
    ChecklistItem(
      is_checked: True,
      text: "I'm checked",
      text_html: "<!-- … snipped for brevity … -->",
    ),
    ChecklistItem(
      is_checked: True,
      text: "I'm also checked",
      text_html: "<!-- … snipped for brevity … -->",
    ),
  ])
}

pub fn note_from_json_with_text_note_test() {
  let note =
    "./test/example_keep_text_note.json"
    |> expect_note_from_file
    |> should_match_note(
      title: "An example Keep text note",
      is_archived: True,
      is_trashed: False,
      created_at: "2024-01-09T18:51:17.418Z",
      edited_at: "2024-01-09T19:53:46.609Z",
      color: color.Default,
      annotations: [],
    )

  note
  |> note.text
  |> should.be_ok
  |> should.equal("Here is some text" <> "\n" <> "that is on multiple lines")

  note
  |> note.text_content_html
  |> should.be_ok
  |> should.equal("<!-- … snipped for brevity … -->")
}

pub fn note_from_json_with_unknown_note_test() {
  "./test/example_keep_unknown.json"
  |> expect_note_from_file
  |> should_match_note(
    title: "My shopping list",
    is_archived: False,
    is_trashed: False,
    created_at: "2017-07-12T18:55:47.649Z",
    edited_at: "2017-07-12T18:55:47.649Z",
    color: color.Default,
    annotations: [
      Annotation(
        description: "",
        source: Weblink,
        title: "",
        url: Uri(
          Some("https"),
          None,
          Some("support.google.com"),
          None,
          "/keep/",
          Some("p=migrated_from_assistant"),
          None,
        ),
      ),
    ],
  )
}

pub fn note_from_json_with_bad_json_test() {
  "./test/example_keep_invalid.json"
  |> read_note
  |> should.be_error
}

// --- Helpers and such

fn expect_note_from_file(filepath: String) -> Note {
  filepath |> read_note |> should.be_ok
}

fn read_file(filepath: String) -> String {
  case simplifile.read(filepath) {
    Ok(str) -> str
    Error(error) -> {
      panic as string.concat([string.inspect(error), " filepath=", filepath])
    }
  }
}

fn read_note(filepath: String) -> Result(Note, json.DecodeError) {
  filepath
  |> read_file
  |> outkeep.note_from_json
}

fn should_match_note(
  note: Note,
  title title: String,
  is_archived is_archived: Bool,
  is_trashed is_trashed: Bool,
  created_at created_at: String,
  edited_at edited_at: String,
  color color: Color,
  annotations annotations: List(Annotation),
) {
  note |> note.title |> should.be_some |> should.equal(title)
  note |> note.is_archived |> should.equal(is_archived)
  note |> note.is_trashed |> should.equal(is_trashed)
  note |> note.created_at |> should_.equal_iso8601(created_at)
  note |> note.edited_at |> should_.equal_iso8601(edited_at)
  note |> note.color |> should.equal(color)
  note |> note.annotations |> should.equal(annotations)
  note
}
