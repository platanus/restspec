RSpec::Matchers.define :include_where do |condition|
  match do |array|
    raise "You can use :include_where with an array response" unless array.is_a?(Array)
    array.any? { |item| condition.call(item) }
  end

  failure_message do |array|
    "expected array to include something according to the block #{condition}"
  end

  failure_message_when_negated do |actual|
    "expected array to not include something according to the block #{condition}"
  end
end
