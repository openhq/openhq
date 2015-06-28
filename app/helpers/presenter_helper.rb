module PresenterHelper
  def present_collection(collection, klass = nil)
    presenters = collection.map { |object| present(object, klass) }
    yield presenters if block_given?
    presenters
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end