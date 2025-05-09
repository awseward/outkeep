import birl.{type Time}
import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/result
import outkeep/checklist.{type Checklist}
import outkeep/text_note.{type TextNote}
import outkeep/unknown_note.{type UnknownNote}

// Not sure if this is actually worth having just yet… Naming the constructors
// is pretty unpleasant, so making it opaque for now and just appending a `_`
// so things don't get too confusing, but I don't love that…

pub type Note {
  Checklist(checklist: Checklist)
  TextNote(text_note: TextNote)
  UnknownNote(unknown_note: UnknownNote)
}

pub fn decode(dyn: Dynamic) -> Result(Note, List(DecodeError)) {
  dyn
  |> dynamic.any([
    fn(d) { d |> checklist.decode |> result.map(with: Checklist) },
    fn(d) { d |> text_note.decode |> result.map(with: TextNote) },
    fn(d) { d |> unknown_note.decode |> result.map(with: UnknownNote) },
  ])
}

pub fn title(n: Note) -> String {
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

pub fn color(n: Note) -> String {
  case n {
    Checklist(checklist:) -> checklist.color
    TextNote(text_note:) -> text_note.color
    UnknownNote(unknown_note:) -> unknown_note.color
  }
}
