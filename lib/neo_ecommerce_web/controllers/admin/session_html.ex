defmodule NeoEcommerceWeb.Admin.SessionHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use NeoEcommerceWeb, :html

  embed_templates "session_html/*"
end
