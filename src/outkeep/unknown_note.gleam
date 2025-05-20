import birl.{type Time}
import gleam/dynamic/decode.{type Decoder}
import gleam/option.{type Option}
import gleam/string
import outkeep/annotation.{type Annotation}
import outkeep/color.{type Color}
import outkeep/time

pub type UnknownNote {
  UnknownNote(
    title: Option(String),
    is_archived: Bool,
    is_pinned: Bool,
    is_trashed: Bool,
    created_at: Time,
    edited_at: Time,
    color: Color,
    annotations: List(Annotation),
  )
}

pub fn decoder() -> Decoder(UnknownNote) {
  use title <- decode.field("title", decode.optional(decode.string))
  use is_archived <- decode.field("isArchived", decode.bool)
  use is_pinned <- decode.field("isPinned", decode.bool)
  use is_trashed <- decode.field("isTrashed", decode.bool)
  use created_at <- decode.field("createdTimestampUsec", time.decoder())
  use edited_at <- decode.field("userEditedTimestampUsec", time.decoder())
  use color <- decode.field("color", color.decoder())
  use annotations <- decode.optional_field(
    "annotations",
    [],
    decode.list(annotation.decoder()),
  )

  decode.success(UnknownNote(
    title: title |> option.map(string.trim),
    is_archived:,
    is_pinned:,
    is_trashed:,
    created_at:,
    edited_at:,
    color:,
    annotations:,
  ))
}
