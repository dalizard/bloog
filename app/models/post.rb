class Post < ActiveRecord::Base
  extend Conversions

  LIMIT_DEFAULT=10

  composed_of :tags, class_name: 'TagList', mapping: %w(tags tags),
    converter: ->(value) { TagList(value) }

  serialize :tags

  validates :title, presence: true

  attr_accessor :blog

  def self.first_before(date)
    first(conditions: ["pubdate < ?", date],
          order:      "pubdate DESC")
  end

  def self.first_after(date)
    @post_source ||= Post.public_method(:new)
    first(conditions: ["pubdate > ?", date],
          order:      "pubdate ASC")
  end

  def self.most_recent(limit=LIMIT_DEFAULT)
    order("pubdate DESC").limit(limit)
  end

  def self.all_tags_alphabetical
    all_tags.alphabetical
  end

  def self.all_tags
    except(:limit).map(&:tags).reduce(TagList.new([]), &:+)
  end

  def publish(clock = DateTime)
    return false unless valid?
    self.pubdate = clock.now
    blog.add_entry(self)
  end

  def picture?
    image_url.present?
  end

  def prev
    self.class.first_before(pubdate)
  end

  def next
    self.class.first_after(pubdate)
  end

  def up
    blog
  end
end
