class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter: allow_cors

  def allow_cors
    headers["Access-Control-Allow-Origin"] = "*"
  end



  def temp
    render plain: "a ldn inbox for scta resources"
  end
  def index
    notifications = Notification.where(target: params[:resourceid]).map do |n|
      "http://#{request.host}/notifications/#{n.id}?resourceid=#{params[:resourceid]}"
    end
    notifications = {
      "@context": "http://www.w3.org/ns/ldp",
      "@id": "http://#{request.host}/notifications?resourceid=#{params[:resourceid]}",
        "contains": notifications
    }
    render :json => notifications
  end
  def create

    body = JSON.parse(request.body.read.html_safe)
    params = {object: body["body"], target: body["target"], updated: body["updated"]}
    @notification = Notification.create(params)
    render plain: "Thanks for sending a POST request"
  end
  def show
    notification = Notification.find(params[:id])
    notification_response = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "@id": "http://#{request.host}/notifications/#{notification.id}?resourceid=#{params[:resourceid]}",
      "@type": "Announce",
      "body": notification.object,
      "target": notification.target,
      "updated": notification.updated,
    }
    render :json => notification_response
  end

end
