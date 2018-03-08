class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      #@feed_items = current_user.feed.paginate(page: params[:page])
      @search_words = params[:search]
      if Micropost.search(@search_words).nil?
        @feed_items = current_user.feed.paginate(page: params[:page])
      else
        @feed_items = Micropost.search(@search_words).paginate(page: params[:page])
      end
    end
  end

  def help
  end
  
  def about
  end
end
