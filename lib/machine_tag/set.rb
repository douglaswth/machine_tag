# Copyright (c) 2013 Douglas Thrift
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'set'

module MachineTag
  # Set of tags which can be machine tags.
  #
  class Set < ::Set
    # The tags in the set which are not machine tags
    #
    # @return [::Set<Tag>] the tags in the set which are not machine tags
    #
    attr_reader :plain_tags

    # The tags in the set which are machine tags
    #
    # @return [::Set<Tag>] the tags in the set which are machine tags
    #
    attr_reader :machine_tags

    # Creates a set of tags which can be machine tags. If String objects are passed in they will be
    # converted to {Tag}.
    #
    # @param enum [Enumerable<Tag, String>, nil] the enumerable object of tags
    # @param block [Proc] the optional block to preprocess elements before inserting them
    #
    def initialize(enum = nil, &block)
      @plain_tags = ::Set[]
      @machine_tags = ::Set[]
      @tags_by_namespace = {}
      @tags_by_namespace_and_predicate = {}
      super
    end

    # Adds a tag to the set of tags. If a String object is passed in it will be converted to {Tag}.
    #
    # @param tag [Tag, String] the tag or string to add
    #
    # @return [Set] the tag set
    #
    def add(tag)
      tag = Tag.new(tag) unless tag.is_a? Tag
      super(tag)

      if tag.machine_tag?
        @machine_tags << tag
        @tags_by_namespace[tag.namespace] ||= ::Set[]
        @tags_by_namespace[tag.namespace] << tag
        @tags_by_namespace_and_predicate[tag.namespace_and_predicate] ||= ::Set[]
        @tags_by_namespace_and_predicate[tag.namespace_and_predicate] << tag
      else
        @plain_tags << tag
      end

      self
    end
    alias_method :<<, :add

    # Retrieves machine tags in the Set with a matching namespace or namespace and predicate.
    #
    # @example
    #   tags = MachineTag::Set['a:b=x', 'a:b=y', 'a:c=z']
    #   tags['a']           # => #<Set: {"a:b=x", "a:b=y", "a:c=z"}>
    #   tags['a', 'b']      # => #<Set: {"a:b=x", "a:b=y"}>
    #   tags['a:c']         # => #<Set: {"a:c=z"}>
    #   tags['a', /^[bc]$/] # => #<Set: {"a:b=x", "a:b=y", "a:c=z"}>
    #   tags[/^a:[bc]$/]    # => #<Set: {"a:b=x", "a:b=y", "a:c=z"}>
    #
    # @param namespace_or_namespace_and_predicate [String, Regexp] the namespace to retrieve or the namespace
    #   and predicate to retreive combined in a string separated by +':'+
    # @param predicate [String, Regexp, nil] the predicate to retreive
    #
    # @return [::Set<Tag>] the machines tags that have the given namespace or namespace and predicate
    #
    def [](namespace_or_namespace_and_predicate, predicate = nil)
      case namespace_or_namespace_and_predicate
      when Regexp
        tags = @machine_tags.select do |machine_tag|
          machine_tag.namespace =~ namespace_or_namespace_and_predicate ||
            machine_tag.namespace_and_predicate =~ namespace_or_namespace_and_predicate
        end

        case predicate
        when nil
        when Regexp
          tags.select! { |machine_tag| machine_tag.predicate =~ predicate }
        else
          raise ArgumentError, "Invalid machine tag predicate: #{predicate.inspect}" unless predicate =~ /^#{PREFIX}$/
          tags.select! { |machine_tag| machine_tag.predicate == predicate }
        end

        ::Set.new tags
      else
        if namespace_or_namespace_and_predicate =~ /^#{PREFIX}$/
          namespace = namespace_or_namespace_and_predicate

          unless predicate
            @tags_by_namespace[namespace] || Set[]
          else
            case predicate
            when Regexp
              ::Set.new @tags_by_namespace[namespace].select { |machine_tag| machine_tag.predicate =~ predicate }
            else
              raise ArgumentError, "Invalid machine tag predicate: #{predicate.inspect}" unless predicate =~ /^#{PREFIX}$/
              @tags_by_namespace_and_predicate["#{namespace}:#{predicate}"] || Set[]
            end
          end
        elsif namespace_or_namespace_and_predicate =~ /^#{NAMESPACE_AND_PREDICATE}$/
          namespace_and_predicate = namespace_or_namespace_and_predicate
          raise ArgumentError, "Separate predicate passed with namespace and predicate: #{namespace_and_predicate.inspect}, #{predicate.inspect}" if predicate
          @tags_by_namespace_and_predicate[namespace_and_predicate] || Set[]
        else
          raise ArgumentError, "Invalid machine tag namespace and/or predicate: #{namespace_or_namespace_and_predicate.inspect}, #{predicate.inspect}"
        end
      end
    end
  end
end
