class TaskSerializer < ActiveModel::Serializer
  attributes :id, :label, :assignment_name
end