require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'haml'

APP_ROOT = File.dirname(__FILE__)
$:.unshift File.join(APP_ROOT, "lib")
require 'resume'

class Resumerator < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  def resumes
    @resumes ||= Resume.all_from(File.join(APP_ROOT, "resumes"))
  end

  get '/' do
    haml :index, locals: { resumes: resumes }
  end

  get '/resumes/:index' do
    resume = resumes[params[:index].to_i - 1]
    haml resume.layout, locals: { resume: resume }
  end
end

Resumerator.run!
