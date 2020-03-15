# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'sassc'

APP_ROOT = File.dirname(__FILE__)
$:.unshift File.join(APP_ROOT, 'lib')
require 'resume'

class Resumerator < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  def resumes
    @resumes ||= Resume.all_from(File.join(APP_ROOT, 'resumes'))
  end

  get '/' do
    haml :index, locals: { resumes: resumes }
  end

  get '/resumes/:index' do
    resume = resumes[params[:index].to_i - 1]
    haml resume.layout, locals: { resume: resume }
  end

  get '/css/*.css' do
    css_file = params[:splat].first
    file_path = File.expand_path("assets/scss/#{css_file}.scss", __dir__)
    if File.exist?(file_path)
      content_type 'text/css'
      SassC::Engine.new(File.read(file_path), style: :compressed).render
    else
      not_found
    end
  end
end

Resumerator.run!
