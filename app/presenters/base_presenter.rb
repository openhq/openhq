class BasePresenter

  def initialize(object, template)
    @object = object
    @template = template
  end

  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def current_user
    h.current_user
  end

  # def method_missing(*args, &block)
  #   @template.send(*args, &block)
  # end

end
