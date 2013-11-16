require 'spec_helper'

describe MachineTag::Set do
  it 'should create sets with plain tags' do
    tags = MachineTag::Set['a', 'b', 'c']
    tags.should eq Set['a', 'b', 'c']
    tags.plain_tags.should eq Set['a', 'b', 'c']
    tags.machine_tags.should be_empty
  end

  it 'should create sets with machine tags' do
    tags = MachineTag::Set['a:b=x', 'a:b=y', 'a:c=z', 'd:e=f']
    tags.should eq Set['a:b=x', 'a:b=y', 'a:c=z', 'd:e=f']
    tags.plain_tags.should be_empty
    tags.machine_tags.should eq Set['a:b=x', 'a:b=y', 'a:c=z', 'd:e=f']
    tags['a'].should eq Set['a:b=x', 'a:b=y', 'a:c=z']
    tags['a:b'].should eq Set['a:b=x', 'a:b=y']
    tags['a', 'c'].should eq Set['a:c=z']
  end

  it 'should create sets with mixed plain and machine tags' do
    tags = MachineTag::Set['a:b=x', 'a:b=y', 'a:c=z', 'd', 'e', 'f']
    tags.should eq Set['a:b=x', 'a:b=y', 'a:c=z', 'd', 'e', 'f']
    tags.plain_tags.should eq Set['d', 'e', 'f']
    tags.machine_tags.should eq Set['a:b=x', 'a:b=y', 'a:c=z']
    tags['a'].should eq Set['a:b=x', 'a:b=y', 'a:c=z']
    tags['a:b'].should eq Set['a:b=x', 'a:b=y']
    tags['a', 'c'].should eq Set['a:c=z']
  end

  describe '#add' do
    let(:tags) { MachineTag::Set.new }

    it 'should add strings' do
      tags << 'a'
      tags.first.should be_an_instance_of(MachineTag::Tag)
    end

    it 'should add tags' do
      tag = MachineTag::Tag.new('a')
      tags << tag
      tags.first.should be(tag)
    end
  end

  describe '#[]' do
    let(:tags) { MachineTag::Set.new }

    it 'should not retrieve with an invalid predicate' do
      expect do
        tags['a', '!']
      end.to raise_error(ArgumentError, 'Invalid machine tag predicate: "!"')
    end

    it 'should not retrieve with a combined namespace and predicate and a predicate' do
      expect do
        tags['a:b', 'c']
      end.to raise_error(ArgumentError, 'Separate predicate passed with namespace and predicate: "a:b", "c"')
    end

    it 'should not retreive with an invalid namespace and/or predicate' do
      expect do
        tags['!']
      end.to raise_error(ArgumentError, 'Invalid machine tag namespace and/or predicate: "!", nil')

      expect do
        tags['a:!']
      end.to raise_error(ArgumentError, 'Invalid machine tag namespace and/or predicate: "a:!", nil')
    end
  end
end
