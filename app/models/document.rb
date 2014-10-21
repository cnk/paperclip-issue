class Document < ActiveRecord::Base
  belongs_to :category, :class_name => 'DocumentCategory', :foreign_key => 'document_category_id'
  
  has_attached_file :file,
                    :storage => :filesystem,
                    :path => ":rails_root/public/system/:class/:id_partition/:filename",
                    :url => "/system/:class/:id_partition/:filename"
  
  validates_attachment :file, :presence => true, :size => { :less_than => 100.megabytes },
      :content_type => { :content_type => [/\Aapplication\/.*\Z/, /\Atext\/.*\Z/]}

end
