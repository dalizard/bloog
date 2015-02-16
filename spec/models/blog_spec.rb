require 'minitest/autorun'
require_relative '../spec_helper_lite'
require_relative '../../app/models/blog'

describe Blog do
  before do
    @entries = []
    @it = Blog.new(-> { @entries })
  end

  it "has no entries" do
    @it.entries.must_be_empty
  end

  describe "#new_post" do
    before do
      @new_post = OpenStruct.new
      @it.post_source = ->{ @new_post }
    end

    it "returns a new post" do
      @it.new_post.must_equal @new_post
    end

    it "sets the post's blog reference to itself" do
      @it.new_post.blog.must_equal @it
    end

    it "accepts an attribute hash on behalf of the post maker" do
      post_source = MiniTest::Mock.new
      post_source.expect(:call, @new_post, [{x: 42, y: 'z'}])
      @it.post_source = post_source
      @it.new_post(x: 42, y: 'z')
      post_source.verify
    end
  end

  describe "#add_entry" do
    it "adds the entry to the blog" do
      entry = stub!
      mock(entry).save
      @it.add_entry(entry)
    end
  end
end
