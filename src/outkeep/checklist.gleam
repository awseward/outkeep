import birl.{type Time}
import gleam/dynamic.{type DecodeError, type Dynamic}
import outkeep/checklist_item.{type ChecklistItem}
import outkeep/time.{time_from_usec}

pub type Checklist {
  Checklist(
    title: String,
    is_archived: Bool,
    is_trashed: Bool,
    items: List(ChecklistItem),
    created_at: Time,
    edited_at: Time,
    color: String,
  )
}

pub fn decode(dyn: Dynamic) -> Result(Checklist, List(DecodeError)) {
  dyn
  |> dynamic.decode7(
    Checklist,
    dynamic.field("title", of: dynamic.string),
    dynamic.field("isArchived", of: dynamic.bool),
    dynamic.field("isTrashed", of: dynamic.bool),
    dynamic.field("listContent", of: dynamic.list(of: checklist_item.decode)),
    dynamic.field("createdTimestampUsec", of: time_from_usec),
    dynamic.field("userEditedTimestampUsec", of: time_from_usec),
    dynamic.field("color", of: dynamic.string),
  )
}
