module Workflow
  module Docker
    extend self

    class Container

      attr_accessor :full_id
      def initialize(name:, image:, network_name:, volumes_from:, environment_variables:)
        command = ["docker create"]
        command << set_container_name(name)
        command << set_network(network_name)

        volumes_from.each { |volume_owner| command << add_volumes_from(volume_owner) }
        environment_variables.each_pair { |key, value| command << add_environment_variable(key.upcase, value) }

        command << set_workdir('/activity')
        command << image
        command << set_file_to_run('run.rb')

        #puts command.join(' ')
        @full_id = %x(#{command.join(' ')})
      end

      def start
      end

      def id
        @full_id.present? ? @full_id[0...12] : nil
      end

      private

      def add_environment_variable(name, value)
        "-e #{name}=#{value}"
      end

      def set_file_to_run(filename)
        "ruby ./#{filename}"
      end

      def set_workdir(workdir_path)
        "-w #{workdir_path}"
      end

      def set_container_name(container_name)
        return if container_name.empty?
        "--name #{container_name}"
      end

      def set_network(network_name)
        return if network_name.empty?
        "--net=#{network_name}"
      end

      def add_volumes_from(container_name)
        return "" if container_name.empty?
        "--volumes-from #{container_name}"
      end
    end
  end
end
