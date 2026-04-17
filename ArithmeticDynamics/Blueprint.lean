import Lean

open Lean

/-- Attribute for blueprint mapping -/
initialize blueprintAttr : TagAttribute ←
  registerTagAttribute `blueprint "Blueprint mapping"
