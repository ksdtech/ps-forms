class ContactItem < ActiveRecord::Base
  belongs_to :version
  has_many :parent_contact_items
  has_many :parents, :through => :parent_contact_items
  has_many :employee_contact_items
  has_many :employees, :through => :employee_contact_items
  
end

class Phone < ContactItem
  REGEXP_VALID = /^\+\s*([0-9][-0-9,\. ]+)$|^(\(?\d{3}[-,\.\/\)]?\s*)?(\d{3})([-,\.]|\s*)(\d{4})([, ]*e?xt?([-\.]|\s*)\d+)?$/

  class << self
    def canonicalize(txt_in)
      ph = nil
      valid = false
      reformatted = false
      if !txt_in.nil?
        txt_in.strip!
        txt = txt_in.downcase
        
        m = REGEXP_VALID.match(txt)
        if m
          valid = true
          if m[1].nil?
            ac = m[2].nil? ? '(415) ' : "(#{m[2].gsub(/[^0-9]/, '')}) "
            loc = "#{m[3]}-#{m[5]}"
            ext = m[6].nil? ? '' : " x#{m[6].gsub(/[^0-9]/, '')}"
            ph = ac + loc + ext
          else
            ph = "+#{m[1].gsub(/[^0-9]+/, ' ')}"
          end
        end
        
        if valid
          if txt_in != ph
            reformatted = true
          else
            ph = txt
          end
        end
      end
      [ ph, valid, reformatted ]
    end
  end
end

class Email < ContactItem
  REGEXP_VALID = /^[a-z0-9._%+-]+\@[a-z0-9.-]+\.([a-z][a-z]|com|biz|edu|gov|int|mil|net|org|pro|aero|coop|info|jobs|name|museum|travel)$/

  class << self
    def canonicalize(txt_in)
      em = nil
      valid = false
      reformatted = false
      if !txt_in.nil?
        txt_in.strip!
        txt = txt_in.downcase
        m = REGEXP_VALID.match(txt)
        if m
          valid = true
          # if txt_in != txt
          #  reformatted = true
          # end
          em = txt
        end
      end
      [ em, valid, reformatted ]
    end
  end
end
