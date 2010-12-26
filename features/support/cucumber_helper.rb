Factory.sequences.each do |name, seq|
  seq.instance_variable_set(:@value, 2000)
end