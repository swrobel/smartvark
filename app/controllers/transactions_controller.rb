class TransactionsController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]
  
  def create
    notify = Paypal::Notification.new(request.raw_post)
  
    # make sure this transaction id is not already logged
    if Transaction.where(:transaction_id => notify.transaction_id).where(:status => "Completed").count.zero?
      if notify.acknowledge
        begin
          Transaction.create!(:params => params, :user_id => params[:custom], :credits => params[:quantity], :status => status, :transaction_id => params[:txn_id] )
        rescue => e
          logger.info e
        ensure
          logger.info "Txn user: " + params[:custom] + " status: " + notify.status + " credits: " + params[:quantity] + " id: " + notify.transaction_id
        end
      else #transaction was not acknowledged
        logger.info "UNACKNOWLEDGED Txn user: " + params[:custom] + " status: " + notify.status + " credits: " + params[:quantity] + " id: " + notify.transaction_id
      end
    end
  
    render :nothing => true
  end
end
