module Bamboo
  autoload :Client, 'bamboo/client'
  autoload :VERSION, 'bamboo/version'

  def self.new(host)
    Client.new(host)
  end
end
