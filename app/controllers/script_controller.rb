require 'securerandom'
require 'socket'
require 'docker'

class ScriptController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def exec

    script = Script.find_by_slug(params[:id])

    image = Docker::Image.get(script.image)

    

    container = image.run(params[:cmd])

    stream_logs(container, "editor_#{script.slug}")

    container.stop
    container.delete(:force => true)
    render nothing: true
  end

  def run
    script = Script.find_by_slug(params[:id])
    _containter = Container.find_by_language(language = params[:language])

    if _containter

      file_path = script.build_file(params[:body])

      _image = Docker::Image.get(script.image)
      image = _image.insert_local('localPath' => file_path, 'outputPath' => '/usr/src/app/')

      WebsocketRails["editor_#{script.slug}"].trigger 'terminal_log', script.run_command

      p "RUN: #{script.run_command}"

      container = image.run(script.run_command)

      stream_logs(container, "editor_#{script.slug}")

      container.stop
      container.delete(:force => true)

      File.delete(file_path)

    end
    render nothing: true

  end

  def index
    @script = Script.new
    @script.slug = SecureRandom.hex(4)
    render :new
  end

  def new
    @script = Script.new
    @script.slug = SecureRandom.hex(4)
    render :new
  end

  def show
    @script = Script.find_by_slug(params[:id])


    if @script.nil?
      @script = Script.new
      @script.slug = params[:id] ? params[:id] : SecureRandom.hex(4)
      render :new
    else
      render :show
    end
  end

  def stream
    if request.post?
      @script = Script.find_by_slug(params[:id])
      @script = Script.new unless @script

      @script.slug = params[:id]
      @script.code = params[:code]
      @script.language = params[:language]
      @script.theme_string = params[:style]
      @script.save
    end
    if request.get?
      @script = Script.find_by_slug(params[:id]) || Script.new({slug: params[:id]})
      puts @script.code.to_json
    end
    render :stream
  end

  def edit
    if request.post?
      @script = Script.find_by_slug(params[:id])
      @script = Script.new unless @script

      @script.slug = params[:id]
      @script.code = params[:code]
      @script.language = params[:language]
      @script.theme_string = params[:style]
      @script.save
    end
    if request.get?
      @script = Script.find_by_slug(params[:id]) || Script.new({slug: params[:id]})
      puts @script.code.to_json
    end
    render :new
  end

  def stream_logs(container, channel)

    container.logs(stdout: true)
    container.logs(stderr: true)

    container.streaming_logs(stdout: true) do |stream, chunk|
      puts "#{stream}: #{chunk}"
      WebsocketRails[channel].trigger 'terminal_stdout', chunk
    end

    container.streaming_logs(stderr: true) do |stream, chunk|
      puts "#{stream}: #{chunk}"
      WebsocketRails[channel].trigger 'terminal_stderr', chunk
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def script_params
    params.require(:script).permit(:slug, :code, :language)
  end
end
