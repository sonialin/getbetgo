require 'heroku-api'
 
module HerokuResqueAutoScale
  module Scaler
    class << self
      @@heroku = Heroku::API.new(:api_key => ENV['HEROKU_API_KEY'])
 
      def workers
        Resque.info[:working]
      end
 
      def workers=(qty)
        @@heroku.post_ps_scale(ENV['HEROKU_APP'], 'resque', qty)
      end
 
      def job_count
        Resque.info[:pending].to_i
      end
    end
  end
 
  def after_perform_scale_down(*args)
    return if !Rails.env.staging? && !Rails.env.production?
    Scaler.workers = 0 if Scaler.job_count.zero?
  end
 
  def after_enqueue_scale_up(*args)
    return if (!Rails.env.staging? && !Rails.env.production?)
    [
      {
        :workers => 1,
        :job_count => 1
      },
      {
        :workers => 2,
        :job_count => 15
      },
      {
        :workers => 3,
        :job_count => 25
      },
      {
        :workers => 4,
        :job_count => 40
      },
      {
        :workers => 5,
        :job_count => 60
      }
    ].reverse_each do |scale_info|
      if Scaler.job_count >= scale_info[:job_count]
        if Scaler.workers <= scale_info[:workers]
          Scaler.workers = scale_info[:workers]
        end
      end
    end
  end
end