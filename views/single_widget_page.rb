class SingleWidgetPage < VegasPage
  needs :widget_class
  
  def main_content
    widget widget_class
  end
end

