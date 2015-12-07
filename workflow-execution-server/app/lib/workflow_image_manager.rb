module WorkflowImageManager
  extend self

  def get_control_flow_activity_images
    registry = Configuration.current.settings['registry']
    return unless registry.present?

    %w[and_split and_join or_split or_join start end].each do |activity|
      begin
        unless Docker::Image.exist? "wfms_#{activity}"
          Docker::Image.create(fromImage: "#{registry}/wfms_#{activity}:latest")
          image = Docker::Image.get("#{registry}/wfms_#{activity}:latest")
          image.tag repo: "wfms_#{activity}", force: true
        end
      rescue
      end
    end
  end
end
