import birl.{type Time}
import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/result
import outkeep/checklist.{type Checklist}
import outkeep/text_note.{type TextNote}
import outkeep/unknown_note.{type UnknownNote}

// Not sure if this is actually worth having just yet… Naming the constructors
// is pretty unpleasant, so making it opaque for now and just appending a `_`
// so things don't get too confusing, but I don't love that…

pub opaque type Note {
  C(checklist: Checklist)
  TN(text_note: TextNote)
  UN(unknown_note: UnknownNote)
}

pub fn decode(dyn: Dynamic) -> Result(Note, List(DecodeError)) {
  dyn
  |> dynamic.any([
    fn(d) { d |> checklist.decode |> result.map(with: C) },
    fn(d) { d |> text_note.decode |> result.map(with: TN) },
    fn(d) { d |> unknown_note.decode |> result.map(with: UN) },
  ])
}

pub fn title(n: Note) -> String {
  case n {
    C(checklist:) -> checklist.title
    TN(text_note:) -> text_note.title
    UN(unknown_note:) -> unknown_note.title
  }
}

pub fn is_archived(n: Note) -> Bool {
  case n {
    C(checklist:) -> checklist.is_archived
    TN(text_note:) -> text_note.is_archived
    UN(unknown_note:) -> unknown_note.is_archived
  }
}

pub fn is_trashed(n: Note) -> Bool {
  case n {
    C(checklist:) -> checklist.is_trashed
    TN(text_note:) -> text_note.is_trashed
    UN(unknown_note:) -> unknown_note.is_trashed
  }
}

pub fn created_at(n: Note) -> Time {
  case n {
    C(checklist:) -> checklist.created_at
    TN(text_note:) -> text_note.created_at
    UN(unknown_note:) -> unknown_note.created_at
  }
}

pub fn edited_at(n: Note) -> Time {
  case n {
    C(checklist:) -> checklist.edited_at
    TN(text_note:) -> text_note.edited_at
    UN(unknown_note:) -> unknown_note.edited_at
  }
}
