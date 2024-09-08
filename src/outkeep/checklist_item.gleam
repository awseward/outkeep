import gleam/dynamic.{type DecodeError, type Dynamic}

pub type ChecklistItem {
  ChecklistItem(is_checked: Bool, text: String)
}

pub fn decode(dyn: Dynamic) -> Result(ChecklistItem, List(DecodeError)) {
  dyn
  |> dynamic.decode2(
    ChecklistItem,
    dynamic.field("isChecked", of: dynamic.bool),
    dynamic.field("text", of: dynamic.string),
  )
}
