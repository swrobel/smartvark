class TransactionsController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]
  
  def create
    notify = Paypal::Notification.new(request.raw_post)
    logger.info notify.inspect
  
    # make sure this transaction id is not already logged
    if !Transaction.count("*", :conditions => ["transaction_id = ?", notify.transaction_id]).zero?
      if notify.acknowledge
        begin
          if notify.complete?
            #Transaction.create!(:params => params, :user_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id] )  
            logger.info "ACKNOWLEDGED!!!"
            logger.info notify.inspect
          else
             #Reason to be suspicious
          end
    
        rescue => e
          logger.info e
        ensure
          #make sure we logged everything we must
        end
      else #transaction was not acknowledged
        logger.info "NOT ACKNOWLEDGED???"
      end
    end
  
    render :nothing => true
  end
end
