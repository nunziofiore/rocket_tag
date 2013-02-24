module RocketTag
  class Tag < ActiveRecord::Base
    has_many :taggings, :dependent => :destroy, :class_name => 'RocketTag::Tagging'
    attr_accessible :name

    validates_presence_of :name
    validates_uniqueness_of :name

    has_and_belongs_to_many :alias, :class_name => "RocketTag::Tag",
                :join_table => "alias_tags",
                :foreign_key => "tag_id",
                :association_foreign_key => "alias_id",
                :uniq => true,
                :after_add => :add_reverse_alias,
                :after_remove => :remove_reverse_alias

    def add_reverse_alias(tag)
      [self.alias, self].flatten.each do |t|
        tag.alias << t if !tag.alias.include?(t) && t != tag
      end
    end   

    def remove_reverse_alias(tag)
      tag.alias.delete(self) if tag.alias.include?(self)
    end  

    def alias?(that)
      return self.alias.include?(that)
    end

    def self.by_taggable_type(type)
      joins{taggings}.where{taggings.taggable_type == type.to_s}
    end

    def tags_count
      self[:tags_count].to_i
    end
    
    def rocket_tag_tag_path
    end

  end
end
