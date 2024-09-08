import birl.{type Time}
import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/result

pub type TextNote {
  TextNote(
    title: String,
    is_archived: Bool,
    is_trashed: Bool,
    text: String,
    created_at: Time,
    edited_at: Time,
  )
}

pub fn decode(dyn: Dynamic) -> Result(TextNote, List(DecodeError)) {
  dyn
  |> dynamic.decode6(
    TextNote,
    dynamic.field("title", of: dynamic.string),
    dynamic.field("isArchived", of: dynamic.bool),
    dynamic.field("isTrashed", of: dynamic.bool),
    dynamic.field("textContent", of: dynamic.string),
    dynamic.field("createdTimestampUsec", of: time_from_usec),
    dynamic.field("userEditedTimestampUsec", of: time_from_usec),
  )
}

fn time_from_usec(dyn: Dynamic) {
  dyn
  |> dynamic.int
  |> result.map(with: birl.from_unix_micro)
}
