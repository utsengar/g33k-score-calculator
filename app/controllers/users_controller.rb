require 'curb'

class UsersController < ApplicationController
  def register_user
    user = User.create(params[:user]) #user saved in database
    service_call(params[:user][:stackoverflow_id], params[:user][:github_id])
    
  end
  
  
  private
  def service_call(stackoverflow_id, github_id)
    
    if stackoverflow_id.exists?
      so_id = ""
      url_so = "http://api.stackoverflow.com/1.0/users/" + so_id #create url here
      curl = Curl::Easy.new(url_so)
    end
    
    if github_id.exists?
      url_git = "http://github.com/api/v2/xml/user/search/" + github_id #create url here
      curl = Curl::Easy.new(url_git)
    end
    
  end
end