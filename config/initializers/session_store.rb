# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_g33k-app_session',
  :secret      => 'b1e7e15aa1232ffa4ef477aaa9744a5f0cb9810fa306f3a067949d39fefe49be226f227b84ef3ed40a6064af6c8cc795f3c5ff5a75357b104eb2426090eeefc4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
