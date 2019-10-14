defmodule I18nHelpers.Plugs.PutLocale do
  @moduledoc false

  import Plug.Conn

  @spec init(list) :: list
  def init(options) do
    Keyword.get(options, :find_locale) ||
      raise ArgumentError, "must supply `find_locale` option"

    options
  end

  @spec call(Plug.Conn.t(), list) :: Plug.Conn.t()
  def call(conn, options) do
    find_locale = Keyword.fetch!(options, :find_locale)
    backend = Keyword.get(options, :backend)

    locale =
      find_locale.(conn) ||
        raise "locale not found in conn #{inspect(conn)}"

    if backend,
      do: Gettext.put_locale(backend, locale),
      else: Gettext.put_locale(locale)

    assign(conn, :locale, locale)
  end
end
