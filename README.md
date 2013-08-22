## Setup instructions

Default database is postgres. If you'd like to use something else, edit the Gemfile & database.yml

1. `rake db:create`
2. `rake db:migrate`
3. echo "COOKIE_SECRET="`rake secret` > .env
4. `rails s`
5. profit

New user accounts are disabled. `git revert 7cb75b0c8fa8fa660326cd90af6ca89a90b5e34a` if you want to re-enable them.
