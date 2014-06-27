require 'spec_helper'

describe MachineTag::Tag do
  it 'should create plain tags' do
    tag = MachineTag::Tag.new('a')
    expect(tag).to eq 'a'
    expect(tag.namespace).to be_nil
    expect(tag.predicate).to be_nil
    expect(tag.namespace_and_predicate).to be_nil
    expect(tag.value).to be_nil
    expect(tag.machine_tag?).to be_falsy
  end

  it 'should create machine tags' do
    tag = MachineTag::Tag.new('a:b=c')
    expect(tag).to eq 'a:b=c'
    expect(tag.namespace).to eq 'a'
    expect(tag.predicate).to eq 'b'
    expect(tag.namespace_and_predicate).to eq 'a:b'
    expect(tag.value).to eq 'c'
    expect(tag.machine_tag?).to be_truthy
  end

  it 'should handle a machine tag with a quoted value' do
    tag = MachineTag::Tag.new('a:b="c d"')
    expect(tag).to eq 'a:b="c d"'
    expect(tag.namespace).to eq 'a'
    expect(tag.predicate).to eq 'b'
    expect(tag.namespace_and_predicate).to eq 'a:b'
    expect(tag.value).to eq 'c d'
    expect(tag.machine_tag?).to be_truthy
  end

  describe '::machine_tag' do
    it 'should create machine tags' do
      tag = MachineTag::Tag.machine_tag('a', 'b', 'c')
      expect(tag).to eq 'a:b=c'
      expect(tag.namespace).to eq 'a'
      expect(tag.predicate).to eq 'b'
      expect(tag.namespace_and_predicate).to eq 'a:b'
      expect(tag.value).to eq 'c'
      expect(tag.machine_tag?).to be_truthy
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
