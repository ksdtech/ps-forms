# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ps-forms-2.3.5_session',
  :secret      => '3c628ea9ea7ba1f55fc8451e875814f937dc9760ec256a9b12936fefae965c70bedb934c0045a5a74c8f6fbde0a7c7c863bf21fcc56bf9d63be9efd190ab8560'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
