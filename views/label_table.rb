class LabelTable < Erector::Widget

  class Field < Erector::Widget
    def initialize(label, note = nil, &contents)
      super(:label => label, :note => note)
      @contents = contents
    end

    def content
      tr do
        th do
          text @label
          text ":" unless @label.nil?
        end
        td do
          @contents.call
        end
        if @note
          td do
            text @note
          end
        end
      end
    end
  end

  def field(label, note = nil, &contents)
    @fields << Field.new(label, note, &contents)
  end
  
  def button(&button_proc)
    @buttons << button_proc
  end

  # todo: use hash args and 'needs'
  
  def initialize(title)
    super(:title => title)
    @fields = []
    @buttons = []
    yield self
  end
  
  def content
    fieldset do
      legend @title
      table :width => '100%' do
        @fields.each do |f|
          widget f
        end
        tr do
          td :colspan => 2, :align => "right" do          
            table :class => 'layout' do
              tr do
                @buttons.each do |button|
                  td do
                    button.call
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
end
