require 'faker'

return unless Rails.env.development?

Rails.root.glob('db/seeds/*.rb').sort.each { |f| load f.to_s }
