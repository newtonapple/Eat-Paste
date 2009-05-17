class << ActiveRecord::Base
  def having(*concerns)
    concerns.each do |concern|
      require_dependency "#{name.underscore}/#{name.underscore}_having_#{concern}"
    end
  end
end