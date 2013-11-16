require 'spec_helper'

describe MachineTag do
  it 'should have a version number' do
    MachineTag::VERSION.should_not be_nil
  end
end
