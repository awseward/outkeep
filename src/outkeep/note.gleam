import birl.{type Time}
import gleam/dynamic/decode.{type Decoder}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import outkeep/annotation
import outkeep/checklist.{type Checklist}
import outkeep/checklist_item.{type ChecklistItem}
import outkeep/color.{type Color}
import outkeep/text_note.{type TextNote}
import outkeep/unknown_note.{type UnknownNote}

pub type Note {
  Checklist(checklist: Checklist)
  TextNote(text_note: TextNote)
  UnknownNote(unknown_note: UnknownNote)
}

pub fn decoder() -> Decoder(Note) {
  decode.one_of(checklist_decoder(), or: [
    text_note_decoder(),
    unknown_note_decoder(),
  ])
}

pub fn is_checklist(n: Note) -> Bool {
  n |> is(checklist)
}

pub fn is_text_note(n: Note) -> Bool {
  n |> is(text_note)
}

pub fn is_unknown_note(n: Note) -> Bool {
  n |> is(unknown_note)
}

pub fn checklist(n: Note) -> Result(Checklist, Nil) {
  case n {
    Checklist(checklist:) -> Ok(checklist)
    _ -> Error(Nil)
  }
}

pub fn checklists(ns: List(Note)) -> List(Checklist) {
  ns |> list.filter_map(checklist)
}

pub fn text_note(n: Note) -> Result(TextNote, Nil) {
  case n {
    TextNote(text_note:) -> Ok(text_note)
    _ -> Error(Nil)
  }
}

pub fn text_notes(ns: List(Note)) -> List(TextNote) {
  ns |> list.filter_map(text_note)
}

pub fn unknown_note(n: Note) -> Result(UnknownNote, Nil) {
  case n {
    UnknownNote(unknown_note:) -> Ok(unknown_note)
    _ -> Error(Nil)
  }
}

pub fn unknown_notes(ns: List(Note)) -> List(UnknownNote) {
  ns |> list.filter_map(unknown_note)
}

pub fn title(n: Note) -> Option(String) {
  case n {
    Checklist(checklist:) -> checklist.title
    TextNote(text_note:) -> text_note.title
    UnknownNote(unknown_note:) -> unknown_note.title
  }
}

pub fn is_archived(n: Note) -> Bool {
  case n {
    Checklist(checklist:) -> checklist.is_archived
    TextNote(text_note:) -> text_note.is_archived
    UnknownNote(unknown_note:) -> unknown_note.is_archived
  }
}

pub fn is_trashed(n: Note) -> Bool {
  case n {
    Checklist(checklist:) -> checklist.is_trashed
    TextNote(text_note:) -> text_note.is_trashed
    UnknownNote(unknown_note:) -> unknown_note.is_trashed
  }
}

pub fn created_at(n: Note) -> Time {
  case n {
    Checklist(checklist:) -> checklist.created_at
    TextNote(text_note:) -> text_note.created_at
    UnknownNote(unknown_note:) -> unknown_note.created_at
  }
}

pub fn edited_at(n: Note) -> Time {
  case n {
    Checklist(checklist:) -> checklist.edited_at
    TextNote(text_note:) -> text_note.edited_at
    UnknownNote(unknown_note:) -> unknown_note.edited_at
  }
}

pub fn color(n: Note) -> Color {
  case n {
    Checklist(checklist:) -> checklist.color
    TextNote(text_note:) -> text_note.color
    UnknownNote(unknown_note:) -> unknown_note.color
  }
}

pub fn annotations(n: Note) -> List(annotation.Annotation) {
  case n {
    UnknownNote(unknown_note:) -> unknown_note.annotations
    _ -> []
  }
}

pub fn items(n: Note) -> Result(List(ChecklistItem), Nil) {
  case n {
    Checklist(checklist:) -> Ok(checklist.items)
    _ -> Error(Nil)
  }
}

pub fn text(n: Note) -> Result(String, Nil) {
  case n {
    TextNote(text_note:) -> Ok(text_note.text)
    _ -> Error(Nil)
  }
}

pub fn text_content_html(n: Note) -> Result(String, Nil) {
  case n {
    TextNote(text_note:) -> Ok(text_note.text_content_html)
    _ -> Error(Nil)
  }
}

fn checklist_decoder() -> Decoder(Note) {
  checklist.decoder() |> decode.map(Checklist)
}

fn text_note_decoder() -> Decoder(Note) {
  text_note.decoder() |> decode.map(TextNote)
}

fn unknown_note_decoder() -> Decoder(Note) {
  unknown_note.decoder() |> decode.map(UnknownNote)
}

fn is(n: Note, by f: fn(Note) -> Result(a, e)) -> Bool {
  n |> f |> result.is_ok
}
