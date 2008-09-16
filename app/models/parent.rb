class Parent < ActiveRecord::Base
  belongs_to :version
  has_many :parent_students
  has_many :students, :through => :parent_students
  has_many :parent_contact_items
  has_many :phones, :through => :parent_contact_items, 
    :source => :contact_item,
    :conditions => "contact_items.contact_type='Phone'"
  has_many :emails, :through => :parent_contact_items, 
    :source => :contact_item,
    :conditions => "contact_items.contact_type='Email'"
    
  def full_name
    "#{first_name} #{last_name}".strip
  end
    
  def add_email(email, primary=false)
    email, valid, reformatted = Email.canonicalize(email)
    if valid
      ver = self.version
      em = emails.find_by_value(email)
      if em.nil?
        em = ver.contact_items.create(:contact_type => 'Email',
          :primary => primary, :value => email)
        ver.parent_contact_items.create(:parent_id => self.id, :contact_item_id => em.id)
      end
    end
  end
  
  def add_phone(phone, location)
    phone, valid, reformatted = Phone.canonicalize(phone)
    if valid
      ver = self.version
      ph = phones.find_by_value(phone)
      if ph.nil?
        ph = ver.contact_items.create(:contact_type => 'Phone', 
          :location => location, :value => phone)
        ver.parent_contact_items.create(:parent_id => self.id, :contact_item_id => ph.id)
      end
    end
  end
end
