class SingleWidgetPage < VegasPage
  def initialize(widget_class)
    super()
    @widget_class = widget_class
  end
  
  def main_content
    widget @widget_class
  end
end

