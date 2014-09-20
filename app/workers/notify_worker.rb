class NotifyWorker
  @queue = :notify_reqeusts

  def self.perform(*args)
    user_id, subject, body, obj_type, obj_id = args
    user = User.find(user_id)
    obj = obj_type.constantize.find(obj_id)
    user.notify(subject, body, obj)
  end
end