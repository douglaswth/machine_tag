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
    attr_reader :machine_tags

    def initialize(enum = nil, &block)
      @machine_tags = ::Set.new
      @tags_by_namespace = {}
      @tags_by_namespace_and_predicate = {}
      super
    end

    def add(tag)
      tag = Tag.new(tag) unless tag.is_a? Tag
      super(tag)

      if tag.machine_tag?
        @machine_tags << tag
        @tags_by_namespace[tag.namespace] ||= ::Set.new
        @tags_by_namespace[tag.namespace] << tag
        @tags_by_namespace_and_predicate[tag.namespace_and_predicate] ||= ::Set.new
        @tags_by_namespace_and_predicate[tag.namespace_and_predicate] << tag
      end
    end

    def [](namespace_or_namespace_and_predicate, predicate = nil)
      if namespace_or_namespace_and_predicate =~ /^#{PREFIX}$/
        namespace = namespace_or_namespace_and_predicate

        unless predicate
          @tags_by_namespace[namespace]
        else
          raise ArgumentError, "Invalid machine tag predicate: #{predicate.inspect}" unless predicate =~ /^#{PREFIX}$/
          @tags_by_namespace_and_predicate["#{namespace}:#{predicate}"]
        end
      elsif namespace_or_namespace_and_predicate =~ /^#{NAMESPACE_AND_PREDICATE}$/
        namespace_and_predicate = namespace_or_namespace_and_predicate
        raise ArgumentError, "Separate predicate passed with namespace and predicate: #{namespace_and_predicate.inspect}, #{predicate.inspect}" if predicate
        @tags_by_namespace_and_predicate[namespace_and_predicate]
      else
        raise ArgumentError, "Invalid machine tag namespace and/or predicate: #{namespace_or_namespace_and_predicate.inspect}, #{predicate.inspect}"
      end
    end
  end
end
