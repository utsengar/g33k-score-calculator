#http://railscasts.com/episodes/136-jquery
#http://www.notgeeklycorrect.com/english/2009/05/18/beginners-guide-to-jquery-ruby-on-rails/

require 'curb'
require 'json'
require "active_support/all"

class UsersController < ApplicationController
  
  

  def create
    @review = Review.create!(params[:review])
    flash[:notice] = "Thank you for reviewing this product"
    respond_to do |format|
      format.html { redirect_to @review.product }
      format.js
    end
  end
  
  #Point of entry
  def register_user
    if(!params[:user].nil?)
     #user = User.create(params[:user]) #user saved in database
     so_url = params[:user][:stackoverflow_id]
     github_id = params[:user][:github_id]
     
     if(!so_url.empty? || !github_id.empty?)
       #Make the service call and get the score       
       @geek_score = service_call(so_url, github_id)
     else
       
     end
    end
  end
  
  def bin_to_ascii_converter
      binary = params[:user][:binary]
    	@converted_value = binary.gsub(/([01]{8})/){|b| b.to_i(2).chr} 
  end
  
  def ascii_to_bin_converter
        puts "hello world!!"
      ascii = params[:user][:ascii]
      @converted_value = ascii.gsub(/[A-Z]{1}/) {|a| a.unpack('B8')}
  end
  
  
  private
  def service_call(stackoverflow_id, github_id)
    geekness = 0
    if stackoverflow_id != ""
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
      if(reputation >= 1000)
        geekness = geekness + 50
      elsif(reputation >= 500)
        geekness = geekness + 25
      elsif(reputation >= 100)
        geekness = geekness + 10
      elsif(reputation < 100)
        geekness = geekness + 5
      end
    end
    
    if github_id != ""
      url_git = "http://github.com/api/v2/json/user/search/" + github_id #create url here
      curl = Curl::Easy.new(url_git)
      curl.perform
      data_obj = JSON.parse(curl.body_str)
      
      array_data = data_obj['users']
      user_Hash = array_data[0] #since we fetch only one user at a time
      
      #Get user data
      username = user_Hash["username"] #utkarsh2012
      followers = user_Hash["followers"] #0
      repos = user_Hash["repos"] #3
      score = user_Hash["score"] #5.03
      
      #Geekness calculation benchmarks
      if(followers >= 10)
        geekness = geekness + 25
      elsif(followers >= 5)
        geekness = geekness + 12.5
      elsif(followers >=2 )
        geekness = geekness + 5
      elsif(followers >=1 )
        geekness = geekness + 1
      end
      
      if(repos > 10)
        geekness = geekness + 25
      elsif(repos >=5 )
        geekness = geekness + 12.5
      elsif(repos >=2 )
        geekness = geekness + 10
      elsif(repos >=1 )
        geekness = geekness + 5
      end
   end
   
   if(github_id == "" || stackoverflow_id == "")
      return_array = [2*geekness, reputation, followers, repos]
   else
      return_array = [geekness, reputation, followers, repos]
   end
   
   return return_array
  end
end