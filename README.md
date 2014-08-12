# MachineTag

[![Gem Version](https://img.shields.io/gem/v/machine_tag.svg?style=flat-square)][gem]
[![Release](https://img.shields.io/github/release/douglaswth/machine_tag.svg?style=flat-square)][release]
[![Build Status](https://img.shields.io/travis/douglaswth/machine_tag.svg?style=flat-square)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/douglaswth/machine_tag.svg?style=flat-square)][gemnasium]

[gem]: https://rubygems.org/gems/machine_tag
[release]: https://github.com/douglaswth/machine_tag/releases/latest
[travis]: http://travis-ci.org/douglaswth/machine_tag
[gemnasium]: https://gemnasium.com/douglaswth/machine_tag

MachineTag is a Ruby library for using machine tags like those used on [Flickr] and [RightScale].

[Flickr]: http://www.flickr.com/help/tags/#613430
[RightScale]: http://support.rightscale.com/12-Guides/RightScale_101/06-Advanced_Concepts/Tagging

## Installation

Add this line to your application's Gemfile:

    gem 'machine_tag'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install machine_tag

## Usage

MachineTag provides two classes for dealing with machine tags and tags in general: `MachineTag::Tag`
and `MachineTag::Set`:

### MachineTag::Tag

The MachineTag::Tag class represents a tag which can either be a machine tag or a plain tag. It 
inherits from [String] so it can be used in the same ways.

[String]: http://ruby-doc.org/core-1.9.3/String.html

```ruby
plain_tag = MachineTag::Tag.new('geotagged')

plain_tag == 'geotagged'    # => true
plain_tag.machine_tag?      # => false

machine_tag = MachineTag::Tag.new('geo:lat=34.4348067')

machine_tag == 'geo:lat=34.4348067'     # => true
machine_tag.machine_tag?                # => true
machine_tag.namespace                   # => "geo"
machine_tag.predicate                   # => "lat"
machine_tag.namespace_and_predicate     # => "geo:lat"
machine_tag.value.to_f                  # => 34.4348067

machine_tag = MachineTag::Tag.machine_tag('geo', 'lon', -119.8016962)

machine_tag == 'geo:lon=-119.8016962'   # => true
machine_tag.machine_tag?                # => true
```

### MachineTag::Set

The `MachineTag::Set` class represents a set of tags and provides a way of looking them up by
namespace or by namespace and predicate. It inherits from the [Set] so it can be used in the same
ways. If `String` objects are passed into it they will automatically be converted to
`MachineTag::Tag` objects.

[Set]: http://ruby-doc.org/stdlib-1.9.3/libdoc/set/rdoc/Set.html

```ruby
tags = MachineTag::Set['geotagged', 'geo:lat=34.4348067', 'geo:lon=-119.8016962']

tags.include?('geotagged')  # => true
tags.plain_tags             # => #<Set: {"geotagged"}>
tags.machine_tags           # => #<Set: {"geo:lat=34.4348067", "geo:lon=-119.8016962"}>
tags['geo']                 # => #<Set: {"geo:lat=34.4348067", "geo:lon=-119.8016962"}>
tags['geo:lat']             # => #<Set: {"geo:lat=34.4348067"}>
tags['geo', 'lon']          # => #<Set: {"geo:lon=-119.8016962"}>
tags[/^geo:(lat|lon)$/]     # => #<Set: {"geo:lat=34.4348067", "geo:lon=-119.8016962"}>
```

More information can be found in the [documentation].

[documentation]: http://rubydoc.info/gems/machine_tag/frame

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
