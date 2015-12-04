require 'fileutils'

class Activity
  def run
    forward_input
    puts "And-Split-Activity did something!!"
  end

  private
  def forward_input
    return unless folders_exist?

    FileUtils.cd('/') { FileUtils.cp_r 'input/', 'output/' }
  end

  def folders_exist?
    Dir.exist?('/input') && Dir.exist?('/output')
  end
end
