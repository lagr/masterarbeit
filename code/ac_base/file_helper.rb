module Activity
  module FileHelper
    extend self

    def workdir
      Activity::Configuration.workdir
    end

    def input_dir
      "#{workdir}/input"
    end

    def output_dir
      "#{workdir}/output"
    end

    def info_data
      "#{Activity::Configuration.confdir}/activity.info.json"
    end

    def input_data
      "#{input_dir}/input.data.json"
    end
  end
end