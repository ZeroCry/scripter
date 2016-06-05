require 'docker'
require 'socket'

class Script < ActiveRecord::Base

  after_create :build_image

  def build_image
    str_dir = "#{Rails.root}/containers/#{self.language}"
    channel = "editor_#{self.slug}"
    _image = Docker::Image.build_from_dir("#{str_dir}") do |v|
      if (log = JSON.parse(v)) && log.has_key?("stream")
        $stdout.puts log["stream"]
        WebsocketRails[channel].trigger 'terminal_log', log["stream"]
      end
    end
    _image.tag('repo' => "#{self.language}", 'tag' => "#{self.slug}.rb")
    _image.push

    self.update_attributes({image: _image.id})
  end



  def build_file(body)
    _conainter = Container.find_by_language(language = self.language)
    str_file_name = "#{self.slug}.#{_conainter.extension_file}"
    str_dir = "#{Rails.root}/containers/#{self.language}"
    str_full_path = "#{str_dir}/#{str_file_name}"

    file = File.open("#{str_full_path}", "w+")
    file.write(body)
    file.close
    return str_full_path
  end

  def run_command
    _containter = Container.find_by_language(language = self.language)
    str_file_name = "#{self.slug}.#{_containter.extension_file}"
    return "#{_containter.command} #{str_file_name}"
  end





end
