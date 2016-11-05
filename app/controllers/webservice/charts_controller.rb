class Webservice::ChartsController < ApplicationController
  
  filters = _process_action_callbacks.map(&:filter) 
  
  skip_before_action(*filters, raise: false)
  skip_after_action(*filters, raise: false)
  skip_around_action(*filters, raise: false)
  
  def website_visits
    @website = Business::Website.find(params[:id].to_i)
    datas = []
    if @website
      started_after = params[:started_after] || 30.days.ago
      datas << {name: 'Visits', type: 'area', data: @website.visits.where('started_at > ?', started_after).group_by_day(:started_at).count}
      datas << {name: 'Views', type: 'spline', data: @website.events.views.where('time > ?', started_after).group_by_day(:time).count}
    end
    render json: datas
  end
  
  def website_most_frequent_words
    @website = Business::Website.find(params[:id].to_i)
    datas = []
    if @website
      top = params[:top].to_i || 8
      datas = @website.words.order(frequency: :desc).limit(top).collect{|w| [w.word, w.frequency]}
    end
    render json: datas
  end
  
  def post_visits
    @post = Blog::Content.find(params[:id].to_i)
    datas = []
    if @post
      started_after = params[:started_after] || 30.days.ago
      datas << {name: 'Visits', type: 'area', data: @post.visits.where('started_at > ?', started_after).group_by_day(:started_at).count}
      datas << {name: 'Views', type: 'spline', data: @post.events.where('time > ?', started_after).group_by_day(:time).count}
    end
    render json: datas
  end
  
  def post_most_frequent_words
    @post = Blog::Content.find(params[:id].to_i)
    datas = []
    if @post
      top = params[:top].to_i || 8
      datas = @post.words.order(frequency: :desc).limit(top).collect{|w| [w.word, w.frequency]}
    end
    render json: datas
  end
  
  def business_most_frequent_hosts
    business = Business.find(params[:id].to_i)
    datas = []
    if business
      top = params[:top].to_i || 8
      top_hosts = business.top_hosts(top)
      datas = top_hosts.datas.collect{|host, frequency| [host.decorate.chart_url, (100 * frequency / top_hosts.total.to_f).round(2)]}
      datas << ['others', (100 * top_hosts.grouped_total / top_hosts.total.to_f).round(2)]
    end
    render json: datas
  end
end