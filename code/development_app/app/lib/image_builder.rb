require 'fileutils'

module ImageBuilder
  extend self

  def build_images(build_configs)
    built_images = { successful: {}, failed: [] }

    build_configs.each do |build_config|
      begin
        image = build_image(build_config)
        built_images[:successful][build_config[:name].to_sym] = image.id
      rescue Exception => e
        images[:failed] << { image: image, exception: e }
      end
    end

    built_images
  end

  def build_image(build_config)
    image = nil
    Dir.mktmpdir do |tmpdir|
      prepare_build_enviroment(tmpdir, build_config[:build_environment])
      image = Docker::Image.build_from_dir(tmpdir)
      image.tag build_config[:tag]
    end
    image
  end

  private

  def prepare_build_enviroment(tmpdir, config)
    config[:files_to_write].each_pair do { |path, content| File.open("#{tmpdir}/#{path}", 'w') { |a| a.write(content) } }
    config[:files_to_copy].each_pair do { |source, target| FileUtils.copy(source, "#{tmpdir}/#{target}") }
  end
end
