web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb 
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE=* bundle exec rake resque:work
dj: bundle exec rake jobs:work