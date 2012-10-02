class ConectionController < ApplicationController

  require "open-uri"
  require 'koala'

  def index
    redirect_to "https://www.facebook.com/dialog/oauth?client_id=198150300197839&redirect_uri=http://localhost:3000/conection/get_token&scope=read_insights,manage_pages&state=connecting"
  end

  def get_token

    uri = "https://graph.facebook.com/oauth/access_token?client_id=198150300197839&redirect_uri=http://localhost:3000/conection/get_token&code=#{params[:code]}&client_secret=4cccc989af8f9c2af392077a8a20ea01"
    result_from_facebook = open(URI.parse(URI.escape(uri))).read
    @access_token = result_from_facebook.split("&")[0].split("=")[1]

    uri = 'https://graph.facebook.com/150032638360488/posts&access_token='+@access_token
    @posts = JSON.parse(open(URI.parse(URI.escape(uri))).read)

    @page_graph = Koala::Facebook::API.new(@access_token)

    @posts["data"].each do |i|
      test = @page_graph.fql_query("SELECT metric, value FROM insights WHERE object_id='#{i["id"]}' AND metric='post_impressions_unique' AND period=period('lifetime')")
      puts "**********************"

      i["impression"] = !test[0].nil? ? test[0]["value"] : 0
      
    end
    
  end

  def after_connect
    
  end

end
