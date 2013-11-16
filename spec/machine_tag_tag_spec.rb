require 'spec_helper'

describe MachineTag::Tag do
  it 'should create plain tags' do
    tag = MachineTag::Tag.new('a')
    tag.should eq 'a'
    tag.namespace.should be_nil
    tag.predicate.should be_nil
    tag.namespace_and_predicate.should be_nil
    tag.value.should be_nil
    tag.machine_tag?.should be_false
  end

  it 'should create machine tags' do
    tag = MachineTag::Tag.new('a:b=c')
    tag.should eq 'a:b=c'
    tag.namespace.should eq 'a'
    tag.predicate.should eq 'b'
    tag.namespace_and_predicate.should eq 'a:b'
    tag.value.should eq 'c'
    tag.machine_tag?.should be_true
  end

  it 'should handle a machine tag with a quoted value' do
    tag = MachineTag::Tag.new('a:b="c d"')
    tag.should eq 'a:b="c d"'
    tag.namespace.should eq 'a'
    tag.predicate.should eq 'b'
    tag.namespace_and_predicate.should eq 'a:b'
    tag.value.should eq 'c d'
    tag.machine_tag?.should be_true
  end

  describe '::machine_tag' do
    it 'should create machine tags' do
      tag = MachineTag::Tag.machine_tag('a', 'b', 'c')
      tag.should eq 'a:b=c'
      tag.namespace.should eq 'a'
      tag.predicate.should eq 'b'
      tag.namespace_and_predicate.should eq 'a:b'
      tag.value.should eq 'c'
      tag.machine_tag?.should be_true
    end

    it 'should not create machine tags with invalid namespaces' do
      expect do
        MachineTag::Tag.machine_tag('!', 'b', 'c')
      end.to raise_error(ArgumentError, 'Invalid machine tag namespace: "!"')
    end

    it 'should not create machine tags with invalid predicates' do
      expect do
        MachineTag::Tag.machine_tag('a', '!', 'c')
      end.to raise_error(ArgumentError, 'Invalid machine tag predicate: "!"')
    end
  end
end
