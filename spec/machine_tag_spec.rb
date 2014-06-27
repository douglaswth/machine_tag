require 'spec_helper'

describe MachineTag do
  it 'should have a version number' do
    expect(MachineTag::VERSION).not_to be_nil
  end
end
