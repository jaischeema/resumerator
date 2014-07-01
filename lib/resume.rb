require 'yaml'
require 'active_support/core_ext/hash'

class Resume
  attr_reader :options, :biodata, :references, :experiences, :summary

  def initialize(file)
    data = YAML.load_file(file).deep_symbolize_keys
    @options      = data[:options]
    @biodata      = Biodata.new(data[:biodata])
    @references   = data[:references].map   { |x| Reference.new(x) }
    @experiences  = data[:experiences].map  { |x| Experience.new(x) }
    @summary      = data[:summary]
  end

  def theme
    options.fetch(:theme, 'simple').to_sym
  end

  def markdown?
    options.fetch(:markdown, true)
  end

  def primary_color
    options.fetch(:primary_color, '#ff9900')
  end

  def secondary_color
    options.fetch(:secondary_color, '#fff')
  end

  class Base
    def initialize(data)
      data.each do |key, value|
        self.send("#{key}=", value)
      end
    end
  end

  class Experience < Base
    ATTRS = [:title, :start, :end, :summary, :points]
    attr_accessor *ATTRS
  end

  class Reference < Base
    ATTRS = [:name, :title, :contact]
    attr_accessor *ATTRS
  end

  class Biodata < Base
    ATTRS = [:name, :email, :address, :phone, :tagline]
    attr_accessor *ATTRS
  end

  def self.all_from(folder)
    Dir["#{folder}/**/*.yml"].map { |file| Resume.new(file) }
  end
end
