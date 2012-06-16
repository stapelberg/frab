class TicketsController < ApplicationController
  if Rails.configuration.ticket_server_type == 'otrs_ticket'
    include OtrsTickets
  else
    include RTTickets
  end

  before_filter :authenticate_user!
  before_filter :require_admin

  def create
    @event = Event.find(params[:event_id])
    remote_id = create_remote_ticket( @conference,  
                                     create_ticket_title(
                                       t(:your_submission, :locale => @event.language),
                                       @event ), 
                                     create_ticket_requestors( @event.speakers ),
                                     current_user.email
                                    )
    if (@event.ticket.nil?)
      @event.ticket = Ticket.new
    end
    @event.ticket.remote_ticket_id = remote_id
    @event.save
    redirect_to event_path( :id => params[:event_id], :method => :get )
  end

end