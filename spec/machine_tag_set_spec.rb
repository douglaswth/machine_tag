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
    let(:tags) { MachineTag::Set[] }

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
      tags[/^a/].should eq Set['aa:cc=1', 'ab:cd=2']
    end

    it 'should retrieve with a Regexp for namespace and predicate as one argument' do
      tags[/^.b:c.$/].should eq Set['ab:cd=2', 'bb:cc=3']
    end

    it 'should retrieve with a Regexp for namespace and a String for predicate' do
      tags[/^[ab]/, 'cc'].should eq Set['aa:cc=1', 'bb:cc=3']
    end

    it 'should retrieve with a String for namespace and Regexp for predicate' do
      tags['cc', /^e/].should eq Set['cc:ee=5', 'cc:ef=6']
    end

    it 'should retrieve with a Regexp for namespace and predicate' do
      tags[/^[abc]/, /^(cc|ee)$/].should eq Set['aa:cc=1', 'bb:cc=3', 'cc:ee=5']
    end

    it 'should return an empty set with a String for namespace and no predicate' do
      tags['xx'].should eq Set[]
    end

    it 'should return an empty set with a String for namespace and predicate' do
      tags['aa', 'xx'].should eq Set[]
    end

    it 'should return an empty set with a String for namespace and predicate as one argument' do
      tags['aa:xx'].should eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and no predicate' do
      tags[/^x/].should eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and predicate as one argument' do
      tags[/^.x:y.$/].should eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and a String for predicate' do
      tags[/^a/, 'xx'].should eq Set[]
    end

    it 'should return an empty set with a String for namespace and Regexp for predicate' do
      tags['cc', /^x/].should eq Set[]
    end

    it 'should return an empty set with a Regexp for namespace and predicate' do
      tags[/^a/, /^x/].should eq Set[]
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
