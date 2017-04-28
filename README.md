# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* System dependencies

        ubuntu 14 or above, mysql, redis, nodejs, git

* Ruby version

        Install rbenv or rvm

        ruby 2.3.1p112

        Clone the git repo

        cd tweet_deck

        bundle install

* Configuration

        Copy config/database.sample.yml as config/database.yml file in the same directory and set your database username and password. if ypu using linus then set the "socket" path right.

* Database creation

        bundle exec rake db:create db:migrate


* Database initialization

* How to run the test suite

        Yet to be implemented

* Services (job queues, cache servers, search engines, etc.)

        TWITTER_KEY=<your app key> TWITTER_SECRET=<your app secret> bundle exec sidekiq -d

* Deployment instructions

        This will run the app in development environment.

        TWITTER_KEY=<your app key> TWITTER_SECRET=<your app secret> bundle exec rails server --binding=<public ip> -d

* To restart the app
        kill $(cat tmp/pids/sidekiq.pid) && TWITTER_KEY=<your app key> TWITTER_SECRET=<your app secret> bundle exec sidekiq -d

        kill $(cat tmp/pids/server.pid) && TWITTER_KEY=<your app key> TWITTER_SECRET=<your app secret> bundle exec rails server --binding=<public ip> -d

* To kill the app server and sidekiq process
        kill $(cat tmp/pids/server.pid) && kill $(cat tmp/pids/sidekiq.pid)

