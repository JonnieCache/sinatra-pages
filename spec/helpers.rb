require 'fileutils'

module HelperMethods
  def file_of(page)
    page.downcase.gsub(' ', '_')
  end

  def separate(text)
    text.chomp.split("\n")
  end

  def create_file_for(page, directory = 'views', content = [])
    page_to_create = page.class == String ? page : page.keys.first
    content << '= "#{params[:page]}"' if content.empty?

    Dir.mkdir "#{directory}/" unless File.exist? "#{directory}/"
    File.open("#{directory}/#{file_of(page_to_create)}.haml", 'w'){|file| content.each{|line| file.puts line}}

    create_file_for(page.values.first, "#{directory}/#{file_of(page.keys.first)}") if page.class == Hash
  end
end