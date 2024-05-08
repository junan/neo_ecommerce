defmodule NeoEcommerceWeb.Admin.SessionHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use NeoEcommerceWeb, :html

  import Phoenix.HTML.Form

  embed_templates "session_html/*"
end
