defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  match "/mockauth/*path" do
    Proxy.forward conn, path, "http://mockauth/"
  end

  match "/upload/*path" do
    Proxy.forward conn, path, "http://file/files/"
  end

  get "/files/:id/download" do
    Proxy.forward conn, [], "http://file/files/" <> id <> "/download"
  end

  match "/files/*path" do
    Proxy.forward conn, path, "http://resource/files/"
  end

  match "/documents/search/*path" do
    Proxy.forward conn, path, "http://musearch/documents/search/"
  end

  match "/documents/index/*path" do
    Proxy.forward conn, path, "http://musearch/documents/search/"
  end

  match "/documents/invalidate/*path" do
    Proxy.forward conn, path, "http://musearch/documents/invalidate/"
  end

  match "/musearch/settings/*path" do
    Proxy.forward conn, path, "http://musearch/settings/"
  end


  match "/documents/*path" do
    Proxy.forward conn, path, "http://resource/documents/"
  end

  match "/document-versions/*path" do
    Proxy.forward conn, path, "http://resource/document-versions/"
  end


  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
