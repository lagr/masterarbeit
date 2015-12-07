require 'fileutils'

class Activity
  def initialize(input_dir, output_dir, input_data)
    @input_dir = input_dir
    @output_dir = output_dir
    @input_data = input_data
  end

  def run
    forward_input
    puts "Start-Activity did something!!"
  end

  private
  def forward_input
    return unless folders_exist?
    Dir.delete(@output_dir)
    File.symlink(@input_dir, @output_dir)
  end

  def folders_exist?
    Dir.exist?(@input_dir) && Dir.exist?(@output_dir)
  end
end
