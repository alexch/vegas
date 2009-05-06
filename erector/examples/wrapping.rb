require "#{File.dirname(__FILE__)}/../lib/erector"

x = Erector::Widget.new do
  p "foo"
end

y = Erector::Widget.new do
  div x
end

puts y.to_s

z = Erector::Widget.new do
  div do
    x.render_to(doc)
  end
end

puts z.to_s

w = Erector::Widget.new do
  div do
    x.render_to(self)
  end
end

puts w.to_s
