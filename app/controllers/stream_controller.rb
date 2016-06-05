require 'pp'

class StreamController < WebsocketRails::BaseController





  def stream
    script = Script.find_by_slug(message[:channel].split("_")[1]) || Script.new({slug: message[:channel].split("_")[1]})
    script.code = message[:fulltext]
    script.save
    WebsocketRails[message[:channel]].trigger 'stream_response', {origin_connection: message[:connection_id], body: message[:body]}
  end
  def cursor_stream
    WebsocketRails[message[:channel]].trigger 'stream_cursor_event', {origin_connection: message[:connection_id], body: message[:position]}
  end
  def change_language
    script = Script.find_by_slug(message[:channel].split("_")[1])
    script.language = message[:language]
    script.save
    WebsocketRails[message[:channel]].trigger 'change_language', {origin_connection: message[:connection_id], body: message[:language]}
  end
  def change_theme
    script = Script.find_by_slug(message[:channel].split("_")[1])
    script.theme_string = message[:theme]
    script.save
    WebsocketRails[message[:channel]].trigger 'change_theme', {origin_connection: message[:connection_id], body: message[:theme]}
  end
  def change_selection
    WebsocketRails[message[:channel]].trigger 'change_selection', {origin_connection: message[:connection_id], body: message[:range]}
  end
end