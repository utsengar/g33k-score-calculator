require 'curb'
require 'JSON'
require "active_support/all"

class UsersController < ApplicationController
  #Point of entry
  def register_user
    
    if(!params[:user].nil?)
     user = User.create(params[:user]) #user saved in database
     geek_score = service_call(params[:user][:stackoverflow_id], params[:user][:github_id])
    end
    
    final_value = calculate_score(geek_score)
    puts final_value
    #redirect_to :action => 'show_embedCode'
    
  end
  
  #Show the final embed code with g33k score!
  def show_embedCode
    
    
  end
  
  private
  def service_call(stackoverflow_id, github_id)
    geekness = 0
    if !stackoverflow_id.nil?
      so_id = stackoverflow_id.split("/")[4] #4th element is the unique ID
      url_so = "http://api.stackoverflow.com/1.0/users/" + so_id + "?type=jsontext" #create url here
      curl = Curl::Easy.new(url_so)
      curl.perform
      json_data = ActiveSupport::Gzip.decompress(curl.body_str)
      
      data_obj = JSON.parse(json_data)
      
      array_data = data_obj['users']
      user_Hash = array_data[0] #since we fetch only one user
      
      #get user data
      username = user_Hash['display_name']
      reputation = user_Hash['reputation']
      
      #Geekness calculation benchmarks
      if(reputation > 100)
        geekness = geekness + 5
      end
    end
    
    if !github_id.nil?
      url_git = "http://github.com/api/v2/json/user/search/" + github_id #create url here
      curl = Curl::Easy.new(url_git)
      curl.perform
      data_obj = JSON.parse(curl.body_str)
      
      array_data = data_obj['users']
      user_Hash = array_data[0] #since we fetch only one user
      
      #Get user data
      username = user_Hash["username"] #utkarsh2012
      followers = user_Hash["followers"] #0
      repos = user_Hash["repos"] #3
      score = user_Hash["score"] #5.03
      
      #Geekness calculation benchmarks
      if(followers > 10)
        geekness = geekness + 2.5
      end
      if(repos > 10)
        geekness = geekness + 2.5
      end
   end
   
   return geekness
  end
  
  def calculate_score(geek_score)
    
    
    return geek_score
  end


end