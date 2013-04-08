## Setup instructions

Default database is postgres. If you'd like to use something else, edit the Gemfile & database.yml

1. `rake db:create`
2. `rake db:migrate`
3. `rake secret`
4. Copy the output from #3
5. `export COOKIE_SECRET=<paste here>`
6. `rails s`
7. profit

New user accounts are disabled. Undo the last commit if you want to re-enable them.