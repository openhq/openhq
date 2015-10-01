class NotificationSerializer < ActiveModel::Serializer
  attributes :user, :notifiable, :action_performed
end