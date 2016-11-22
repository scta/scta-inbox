class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    notifications = Notification.all.map {|n| "http://localhost:3000/notifications/#{n.id}"}
    notifications = {
      "@context": "http://www.w3.org/ns/ldp",
      "@id": "http://inbox.scta.info/notifications",
        "contains": notifications
    }
    render :json => notifications
    #render :json => info
  end
  def create
    body = JSON.parse(request.body.read.html_safe)
    test_params = {actor: body["actor"], object: body["object"], target: body["target"], updated: body["updated"]}
    @notification = Notification.create(test_params)

    render plain: "Thanks for sending a POST request with cURL! Payload: #{request.body.read}"
  end
  def show
    notification = Notification.find(params[:id])
    notification_response = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "@id": "http://inbox.scta.info/notifications/#{notification.id}",
      "@type": "Announce",
      "actor": notification.actor,
      "object": notification.object,
      "target": notification.target,
      "updated": notification.updated
    }
    render :json => notification_response
  end

end
