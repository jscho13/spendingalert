class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def log_stderr(output)
    Rails.logger.warn(
      "Stderr contents: #{output}"
    )
  end

  def log_stdout(output)
    Rails.logger.info(
      "Stdout contents: #{output}"
    )
  end
end
