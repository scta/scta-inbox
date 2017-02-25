class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def temp
    render plain: "a ldn inbox for scta resources"
  end
  def options
    response.set_header("Host", "#{request.host}")
    response.set_header("Allow", "GET, HEAD, OPTIONS, POST")
    response.set_header("Accept-Post", "application/ld+json, text/turtle")
    render plain: "Thanks for sending an #{request.request_method} request"
  end
  def index
    response.set_header("Host", "#{request.host}")
    response.set_header("Accept", "application/ld+json")
    response.set_header("Content-Type", "application/ld+json")

    response.set_header("Access-Control-Allow-Origin", "*")
    response.set_header("Access-Control-Allow-Methods", %w{GET POST PUT DELETE}.join(","))
    response.set_header("Access-Control-Allow-Headers", %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(","))

    notifications = Notification.where(target: params[:resourceid]).map do |n|
      {"@id": "http://#{request.host}/notifications/#{n.id}?resourceid=#{params[:resourceid]}"}
    end
    notifications = {
      "@context": "http://www.w3.org/ns/ldp",
      "@type": "ldp:Container",
      "@id": "http://#{request.host}/notifications?resourceid=#{params[:resourceid]}",
        "ldp:contains": notifications
    }
    render :json => notifications
  end
  def create
    response.set_header("Content-Type", "application/ld+json")
    response.set_header("Host", "#{request.host}")

    body = JSON.parse(request.body.read.html_safe)
    params = {object: body["body"], target: body["target"], motivation: body["motivation"], updated: body["updated"]}
    # conditional is primitive way to weed out notifications that don't comply with current expectations of inbox
    
    if params[:object] != nil || params[:target] != nil
      @notification = Notification.create(params)
      response.set_header("Location", "http://#{request.host}/notifications/#{@notification.id}?resourceid=#{body["target"]}")
      render plain: "Thanks for sending a POST request", status: 201
    else
      render plain: "Thanks for sending a POST request, but this request cannot be accepted by this inbox", status: 406
    end


  end
  def show
    response.set_header("Host", "#{request.host}")
    response.set_header("Accept", "application/ld+json")
    response.set_header("Content-Type", "application/ld+json")

    response.set_header("Access-Control-Allow-Origin", "*")
    response.set_header("Access-Control-Allow-Methods", %w{GET POST PUT DELETE}.join(","))
    response.set_header("Access-Control-Allow-Headers", %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(","))


    notification = Notification.find(params[:id])
    notification_response = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "@id": "http://#{request.host}/notifications/#{notification.id}?resourceid=#{params[:resourceid]}",
      "@type": "Announce",
      "motivation": notification.motivation,
      "body": notification.object,
      "target": notification.target,
      "updated": notification.updated,
    }
    render :json => notification_response
  end

end
