module ApplicationHelper
  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    string = block.call
    self.formats = old_formats
    string
  end
end
