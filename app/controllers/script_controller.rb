require 'securerandom'
require 'socket'

hostname = 'localhost'
port = 3000

class ScriptController < ApplicationController

  skip_before_filter :verify_authenticity_token,

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

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def script_params
    params.require(:script).permit(:slug, :code, :language)
  end
end
