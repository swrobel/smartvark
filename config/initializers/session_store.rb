# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_smartvark_session',
  :secret      => 'cfa1cccc3526442ed46efa7bb3b0a57e1daa5c3dda346c7cbf2d2231de07245c35f5ed610120bf8f758d61f58fec8b0107f5b4ffdb8ed9ba9a79a266142898c3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
