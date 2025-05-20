import birl.{type Time}
import gleam/dynamic/decode.{type Decoder}
import gleam/option.{type Option}
import outkeep/checklist_item.{type ChecklistItem}
import outkeep/color.{type Color}
import outkeep/unknown_note

pub type Checklist {
  Checklist(
    title: Option(String),
    is_archived: Bool,
    is_pinned: Bool,
    is_trashed: Bool,
    items: List(ChecklistItem),
    created_at: Time,
    edited_at: Time,
    color: Color,
  )
}

pub fn decoder() -> Decoder(Checklist) {
  use items <- decode.field(
    "listContent",
    decode.list(checklist_item.decoder()),
  )
  use unknown_note <- decode.then(unknown_note.decoder())

  decode.success(Checklist(
    title: unknown_note.title,
    is_archived: unknown_note.is_archived,
    is_pinned: unknown_note.is_pinned,
    is_trashed: unknown_note.is_trashed,
    created_at: unknown_note.created_at,
    edited_at: unknown_note.edited_at,
    color: unknown_note.color,
    items:,
  ))
}
