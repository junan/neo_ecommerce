defmodule NeoEcommerceWeb.Admin.CategoryHTML do
  use NeoEcommerceWeb, :html

  import Phoenix.HTML.Form
  use PhoenixHTMLHelpers

  import Torch.TableView
  import Torch.Component

  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, Torch.Component.translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  embed_templates "category_html/*"
end
