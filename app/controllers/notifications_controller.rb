class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    query_params = {}
    #todo: change actor to source in db and here
    if params[:actor] then query_params[:actor] = (params[:actor]) end
    #target condition is done separately, because it is in the db as a json array
    if params[:target]
      notifications = Notification.where(query_params).map do |n|
        if n.target.include? params[:target]
          "http://localhost:3000/notifications/#{n.id}"
        end
      end
      notifications.compact!
    else
      notifications = Notification.where(query_params).map {|n| "http://localhost:3000/notifications/#{n.id}"}
    end
    notifications = {
      "@context": "http://www.w3.org/ns/ldp",
      "@id": "http://inbox.scta.info/notifications",
        "contains": notifications
    }
    render :json => notifications
  end
  def create
    body = JSON.parse(request.body.read.html_safe)
    test_params = {actor: body["source"], object: body["object"], target: body["target"], updated: body["updated"], same_as: body["@id"]}

    @notification = Notification.create(test_params)

    render plain: "Thanks for sending a POST request with cURL! Payload: #{request.body.read}"
  end
  def show
    notification = Notification.find(params[:id])
    notification_response = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "@id": "http://inbox.scta.info/notifications/#{notification.id}",
      "@type": "Announce",
      "source": notification.actor,
      "object": notification.object,
      "target": notification.target,
      "updated": notification.updated,
      "same_as": notification.same_as
    }
    render :json => notification_response
  end

end
