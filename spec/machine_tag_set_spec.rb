require 'spec_helper'

describe MachineTag::Set do
  it 'should create sets with plain tags' do
    tags = MachineTag::Set['a', 'b', 'c']
    expect(tags).to eq Set['a', 'b', 'c']
    expect(tags.plain_tags).to eq Set['a', 'b', 'c']
    expect(tags.machine_tags).to be_empty
  end

  it 'should create sets with machine tags' do
    tags = MachineTag::Set['a:b=x', 'a:b=y', 'a:c=z', 'd:e=f']
    expect(tags).to eq Set['a:b=x', 'a:b=y', 'a:c=z', 'd:e=f']
    expect(tags.plain_tags).to be_empty
    expect(tags.machine_tags).to eq Set['a:b=x', 'a:b=y', 'a:c=z', 'd:e=f']
    expect(tags['a']).to eq Set['a:b=x', 'a:b=y', 'a:c=z']
    expect(tags['a:b']).to eq Set['a:b=x', 'a:b=y']
    expect(tags['a', 'c']).to eq Set['a:c=z']
  end

  it 'should create sets with mixed plain and machine tags' do
    tags = MachineTag::Set['a:b=x', 'a:b=y', 'a:c=z', 'd', 'e', 'f']
    expect(tags).to eq Set['a:b=x', 'a:b=y', 'a:c=z', 'd', 'e', 'f']
    expect(tags.plain_tags).to eq Set['d', 'e', 'f']
    expect(tags.machine_tags).to eq Set['a:b=x', 'a:b=y', 'a:c=z']
    expect(tags['a']).to eq Set['a:b=x', 'a:b=y', 'a:c=z']
    expect(tags['a:b']).to eq Set['a:b=x', 'a:b=y']
    expect(tags['a', 'c']).to eq Set['a:c=z']
  end

  describe '#add' do
    let(:tags) { MachineTag::Set[] }

    it 'should add strings' do
      tags << 'a'
      expect(tags.first).to be_an_instance_of(MachineTag::Tag)
    end

    it 'should add tags' do
      tag = MachineTag::Tag.new('a')
      tags << tag
      expect(tags.first).to be(tag)
    end
  end

  describe '#[]' do
    let(:tags) do
      MachineTag::Set[
        'aa:cc=1',
        'ab:cd=2',
        'bb:cc=3',
        'ba:dd=4',
        'cc:ee=5',
        'cc:ef=6',
        'cc:ff=7',
      ]
    end

    it 'should retrieve with a Regexp for namespace and no predicate' do
      expect(tags[/^a/]).to eq Set['aa:cc=1', 'ab:cd=2']
    end

    it 'should retrieve with a Regexp for namespace and predicate as one argument' do
      expect(tags[/^.b:c.$/]).to eq Set['ab:cd=2', 'bb:cc=3']
    end

    it 'should retrieve with a Regexp for namespace and a String for predicate' do
      expect(tags[/^[ab]/, 'cc']).to eq Set['aa:cc=1', 'bb:cc=3']
    end

    it 'should retrieve with a String for namespace and Regexp for predicate' do
      expect(tags['cc', /^e/]).to eq Set['cc:ee=5', 'cc:ef=6']
    end

    it 'should retrieve with a Regexp for namespace and predicate' do
      expect(tags[/^[abc]/, /^(cc|ee)$/]).to eq Set['aa:cc=1', 'bb:cc=3', 'cc:ee=5']
    end

    it 'should return an empty set with a String for namespace and no predicate' do
      expect(tags['xx']).to eq Set[]
    end

    it 'should return an empty set with a String for namespace and predicate' do
      expect(tags['aa', 'xx']).to eq Set[]
    end

    it 'should return an empty set with a String for namespace and predicate as one argument' do
      expect(tags['aa:xx']).to eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and no predicate' do
      expect(tags[/^x/]).to eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and predicate as one argument' do
      expect(tags[/^.x:y.$/]).to eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and a String for predicate' do
      expect(tags[/^a/, 'xx']).to eq Set[]
    end

    it 'should return an empty set with a String for namespace and Regexp for predicate' do
      expect(tags['cc', /^x/]).to eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and predicate' do
      expect(tags[/^a/, /^x/]).to eq Set[]
    end

    it 'should not retrieve with an invalid predicate' do
      expect do
        tags['a', '!']
      end.to raise_error(ArgumentError, 'Invalid machine tag predicate: "!"')
      expect do
        tags[/a/, '!']
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
