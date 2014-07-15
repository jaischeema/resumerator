require 'yaml'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object'

class Resume
  attr_reader :options, :biodata, :attributes, :order

  def initialize(file)
    data = YAML.load_file(file).deep_symbolize_keys
    @options      = data[:options]
    @biodata      = Biodata.new(data[:biodata])
    @attributes   = {}
    data.except(:options, :biodata).each do |key, value|
      if value.is_a? Array
        @attributes[key] = value.map { |x| ResumeItem.new(x) }
      else
        @attributes[key] = value
      end
    end
  end

  def theme
    options.fetch(:theme, 'simple')
  end

  def css_file
    (options[:css_file].presence || theme).to_s
  end

  def layout
    (options[:layout].presence || theme).to_sym
  end

  def method_missing(method_name, *arguments, &block)
    if @attributes.include?(method_name.to_sym)
      @attributes[method_name.to_sym]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @attributes.include?(method_name.to_sym) || super
  end

  def markdown?
    options.fetch(:markdown, true)
  end

  def self.all_from(folder)
    Dir["#{folder}/**/*.yml"].map { |file| Resume.new(file) }
  end
end


class Biodata
  attr_accessor :name, :email, :address, :phone, :tagline

  def initialize(data)
    data.each do |key, value|
      self.send("#{key}=", value)
    end
  end
end


class ResumeItem
  attr_accessor :title, :sub_title, :description, :points

  def initialize(data)
    data.each do |key, value|
      self.send("#{key}=", value)
    end
  end
end
