require 'contact_item'

class Student < ActiveRecord::Base
  belongs_to :version
  has_many :family_students
  has_many :families, :through => :family_students
  has_many :parent_students
  has_many :parents, :through => :parent_students
  has_many :events, :as => :table_row
  has_many :related_events, :class_name => 'Event', :as => :related_row

  validates_presence_of :last_name, :on => :create
  validates_presence_of :first_name, :on => :create
  validates_numericality_of :student_number, :on => :create, :only_integer => true, :greater_than => 0
  validates_numericality_of :schoolid, :on => :create, :only_integer => true
  validates_numericality_of :grade_level, :on => :create, :only_integer => true
  validates_numericality_of :enroll_status, :on => :create, :only_integer => true
  validates_numericality_of :home_id, :on => :create, :only_integer => true, :greater_than => 0
  
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_grade_level
    grade_level == 0 ? 'K' : grade_level.to_s
  end
  
  def display_school_meds
    school_meds_office ? "Regular medication form on file" : "No regular medication form on file"
  end
  
  def display_72_hour_meds
    emergency_meds_complete ? "72-hour medication form on file" : "No 72-hour medication form on file"
  end
  
  def to_s
    "#{last_name}, #{first_name} #{student_number} (#{display_grade_level})"
  end
  
  def reg_year
    "#{APP_CONFIG[:current_year]}-#{APP_CONFIG[:current_year] + 1}"
  end

  def short_reg_year
    APP_CONFIG[:current_year].to_s
  end
  
  PARENT_LAST =  {
    'mother' => 'mother',
    'father' => 'father',
    'mother2' => 'mother2_last',
    'father2' => 'father2_last' }
    
  EMERG_PHONE = {
    '1' => [ 'emerg_phone_1', 'emerg_1_ptype', 'emerg_1_alt_phone', 'emerg_1_alt_ptype' ],
    '2' => [ 'emerg_phone_2', 'emerg_2_ptype', 'emerg_2_alt_phone', 'emerg_2_alt_ptype' ],
    '3' => [ 'emerg_3_phone', 'emerg_3_ptype', 'emerg_3_alt_phone', 'emerg_3_alt_ptype' ],
    'x' => [ 'emerg_x_phone', 'emerg_x_ptype', 'emerg_x_alt_phone', 'emerg_x_alt_ptype' ],
  }
  
  # method_missing madness to find the legal guardian
  def guardian_key(except_this, strict)
    [ 'mother', 'father', 'mother2', 'father2' ].each do |key|
      if key != except_this && self["#{key}_isguardian"] &&
        !self[PARENT_LAST[key]].blank? && !self["#{key}_first"].blank?
        return key
      end
    end
    unless strict
      [ 'mother', 'father', 'mother2', 'father2' ].each do |key|
        if key != except_this && 
          !self[PARENT_LAST[key]].blank? && !self["#{key}_first"].blank?
          return key
        end
      end
    end
    nil
  end

  # find first guardian
  def g1_key(strict=false)
    guardian_key(nil, strict)
  end

  # find first guardian by getting first guardian, then looking again
  def g2_key(strict=false)
    guardian_key(g1_key, strict)
  end

  # changes g1_street to street or home2_street
  # changes g1_last to mother or father2_last
  def method_missing(method_id, *arguments)
    # REMOVE THIS WHEN WE HAVE DOUBLE-CHECKED ALL GUARDIAN DATA
    strict = false
    method_name = method_id.id2name
    if method_name =~ /^g([12])_(.+)$/
      # call g1_key or g2_key above
      gkey = ($1 == '1') ? g1_key(strict) : g2_key(strict)
      return '' if gkey.nil?

      attr_part = $2
      attr_name = case attr_part
      when /street|city|state|zip|res_phone/
        if gkey =~ /2/
          if attr_part =~ /res_phone/
            'home2_phone'
          elsif attr_part =~ /^mailing/
            attr_part.gsub(/mailing/, 'mailing2')
          else
            "home2_#{attr_part}"
          end
        else
          if attr_part =~ /res_phone/
            'home_phone'
          else
            attr_part
          end
        end
      when /last/
        PARENT_LAST[gkey]
      else
        "#{gkey}_#{attr_part}"
      end
      return self[attr_name]
    elsif method_name =~ /^e([123x])_(home|work|cell)(_phone)?$/
      ptype = $2
      phone_list = EMERG_PHONE[$1]
      i = 0
      while i < phone_list.size do
        this_ptype = self[phone_list[i+1]]
        if !this_ptype.blank? && this_ptype.downcase == ptype
          return self[phone_list[i]]
        end
        i += 2
      end
      return ''
    end
    super
  end
  
  def validate_all(av)
    validate_user
    validate_home_fields
    validate_guardianemail
    validate_parent_emails(av)
    validate_parent_phones
  end
  
  def validate_user
  end

  def validate_home_fields
    home_fields_required = [ 'web_id', 'web_password',
      'street', 'city', 'state', 'zip',
      'mailing_street', 'mailing_city', 'mailing_state', 'mailing_zip' ]
    home_fields_optional = [
      'mother_first', 'mother', 
      'mother_home_phone', 'mother_work_phone', 'mother_cell',
      'mother_email', 'mother_email2',
      'father_first', 'father', 
      'father_home_phone', 'father_work_phone', 'father_cell',
      'father_email', 'father_email2' ]
    home2_fields_required = [ 'student_web_id', 'student_web_password',
      'home2_street', 'home2_city', 'home2_state', 'home2_zip',
      'mailing2_street', 'mailing2_city', 'mailing2_state', 'mailing2_zip' ]
    home2_fields_optional = [
      'mother2_first', 'mother2_last', 
      'mother2_home_phone', 'mother2_work_phone', 'mother2_cell',
      'mother2_email', 'mother2_email2',
      'father2_first', 'father2_last', 
      'father2_home_phone', 'father2_work_phone', 'father2_cell',
      'father2_email', 'father2_email2' ]
    if self.home_id == 0
      version.events.create(:event_type => 'validation',
        :description => 'primary home id is missing',
        :record_summary => self.to_s,
        :table_row_type => 'Student', 
        :table_row_id => self.id,
        :table_column => 'home_id',
        :table_row_value => self.home_id)
    else
      home_fields_required.each do |k|
        if self[k].blank?
          version.events.create(:event_type => 'validation',
            :description => 'required field is missing for primary family',
            :record_summary => self.to_s,
            :table_row_type => 'Student', 
            :table_row_id => self.id,
            :table_column => k,
            :table_row_value => '')
        end
      end
    end
    if self.home2_id == 0
      (home2_fields_required + home2_fields_optional).each do |k|
        if !self[k].blank?
          version.events.create(:event_type => 'validation',
            :description => 'secondary home id is missing when related field is present',
            :record_summary => self.to_s,
            :table_row_type => 'Student', 
            :table_row_id => self.id,
            :table_column => 'home2_id',
            :table_row_value => self.home2_id,
            :related_row_type => 'Student',
            :related_row_id => self.id,
            :related_column => k,
            :related_row_value => self[k])
        end
      end
    else
      home2_fields_required.each do |k|
        if self[k].blank?
          version.events.create(:event_type => 'validation',
            :description => 'required field is missing for secondary family',
            :record_summary => self.to_s,
            :table_row_type => 'Student', 
            :table_row_id => self.id,
            :table_column => k,
            :table_row_value => '')
        end
      end
    end
  end

  def validate_parent_emails(av)
    [ 'mother_email', 'mother_email2', 
      'father_email', 'father_email2', 
      'mother2_email', 'mother2_email2', 
      'father2_email', 'father2_email2' ].each do |k|
      em, valid, reformatted = Email.canonicalize(self[k])
      next if em.nil?
      if reformatted
        version.events.create(:event_type => 'format',
          :description => 'reformatted email',
          :record_summary => self.to_s,
          :table_row_type => 'Student', 
          :table_row_id => self.id,
          :table_column => k,
          :table_row_value => self[k],
          :corrected_value => em)
      end
      if valid
        av.add_email(self, k, em)
      else
        version.events.create(:event_type => 'validation',
          :description => 'invalid email address',
          :record_summary => self.to_s,
          :table_row_type => 'Student', 
          :table_row_id => self.id,
          :table_column => k,
          :table_row_value => self[k])
      end
    end
  end

  def validate_parent_phones
    [ 'mother_home_phone', 'mother_work_phone', 'mother_cell',
      'father_home_phone', 'father_work_phone', 'father_cell',
      'mother2_home_phone', 'mother2_work_phone', 'mother2_cell',
      'father2_home_phone', 'father2_work_phone', 'father2_cell' ].each do |k|
      ph, valid, reformatted = Phone.canonicalize(self[k])
      next if ph.nil?
      if reformatted
        version.events.create(:event_type => 'format',
          :description => 'reformatted phone number',
          :record_summary => self.to_s,
          :table_row_type => 'Student', 
          :table_row_id => self.id,
          :table_column => k,
          :table_row_value => self[k],
          :corrected_value => ph)
      elsif !valid
        version.events.create(:event_type => 'validation',
          :description => 'invalid phone number',
          :record_summary => self.to_s,
          :table_row_type => 'Student', 
          :table_row_id => self.id,
          :table_column => k,
          :table_row_value => self[k])
      end
    end
  end

  def validate_guardianemail
    if !guardianemail.blank?
      guardianemail.split(/[,\s]+/).each do |gnem|
        em, valid, reformatted = Email.canonicalize(gnem)
        next if em.nil?
        p_emails = all_parent_email_addresses
        if valid
          if !p_emails.include?(em)
            version.events.create(:event_type => 'validation',
              :description => 'email address not registered to parent',
              :record_summary => self.to_s,
              :table_row_type => 'Student', 
              :table_row_id => self.id,
              :table_column => 'guardianemail',
              :table_row_value => em)
          end
        else
          version.events.create(:event_type => 'validation',
            :description => 'invalid email address',
            :record_summary => self.to_s,
            :table_row_type => 'Student', 
            :table_row_id => self.id,
            :table_column => 'guardianemail',
            :table_row_value => gnem)
        end
      end
    end
    true
  end

  def all_parent_email_addresses
    p_emails = { }
    parents.each do |p|
      p.emails.each { |e| p_emails[e.value] = 1 }
    end
    p_emails.keys
  end

  def add_to_family(home_id, primary,
      username, password,
      street, city, state, zip,
      mailing_street, mailing_city, mailing_state, mailing_zip,
      home_phone)
    puts "#{self.student_number} add_to_family #{home_id}"
    f = version.families.find(:first, :conditions => ["home_id=?", home_id])
    if f.nil?
      f = version.families.build(
        :home_id => home_id, 
        :powerschool_password => password,
        :street => street,
        :city => city,
        :state => state,
        :zip => zip,
        :mailing_street => mailing_street,
        :mailing_city => mailing_city,
        :mailing_state => mailing_state,
        :mailing_zip => mailing_zip,
        :home_phone => home_phone)
      f.save
    else
      # check or update family record?
    end
    fs = version.family_students.build(
      :student_id => self.id,
      :family_id => f.id, 
      :powerschool_username => username,
      :primary => primary)
    fs.save(false)
    fs.add_user
    f
  end
  
  def add_parent(family_id, link, staff_id, last_name, first_name, emails, phones)
    return if last_name.blank? || first_name.blank?
    home_number, parent_number = link.split(/_/)
    par = version.parents.find(:first, 
      :conditions => ["family_id=? AND parent_number=?", family_id, parent_number])
    if par.nil?
      attrs = { 
        :family_id => family_id,
        :parent_number => parent_number,
        :last_name => last_name,
        :first_name => first_name }
      attrs[:staff_id] = staff_id unless staff_id.nil? || staff_id.to_i == 0
      puts "adding parent #{first_name} #{last_name}"
      par = version.parents.create(attrs)
    else
      puts "found parent #{par.first_name} #{par.last_name}"
      # check or update parent record?
    end
    puts "adding parent link #{par.id} #{link}"
    ps = version.parent_students.build(
      :student_id => self.id,
      :parent_id => par.id,
      :link => link)
    ps.save(false)
    emails.each_with_index { |em, i| par.add_email(em, i==0) }
    phones.each { |location, phone| par.add_phone(phone, location.to_s) }
  end
  
  def username
    network_id
  end
  
  def password
    network_password
  end

  def find_user
    username.blank? ? nil : User.find(:first, :conditions => ['username=?', username])
  end
  
  def add_user
    if username.blank? || password.blank?
      puts "no username/password for student #{full_name}"
    else
      u = find_user
      if !u.nil?
        puts "already have a user for student #{full_name}: username #{u.username}"
      else
        begin
          u = User.create(:email => "#{username}\@kentstudents.org",
            :student_number => student_number,
            :username => username,
            :password => password,
            :first_name => first_name,
            :last_name => last_name,
            :access_type => 'student')
          u.save
          ur = u.user_roles.build(:role_id => 108)
          ur.save
        rescue
          puts "failed to add user for student #{full_name}: #{$!}"
        end
      end
    end
  end
  
  class << self
    
    def has_attribute?(key)
      (@col_keys ||= column_names).include?(key.to_s)
    end
    
    def bool_convert(attrs, key)
      return if attrs[key].nil?
      test = attrs[key].to_s.downcase
      if ['true','t','1','yes','on'].include?(test)
        attrs[key] = true
      elsif ['false','f','0','no','off'].include?(test)
        attrs[key] = false
      end
    end
    
    def bool_fix(fname='students.txt')
      ver = Version.current
      options = { :students_only => false, :col_sep => "\t", :row_sep => "\n" }
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0,1] == '/'
      UnquotedCSV.foreach(fname, 
        :col_sep => options[:col_sep], :row_sep => options[:row_sep],
        :headers => true, :header_converters => :symbol) do |row|
        begin
          
          puts "fix student #{row[:student_number]}"
          s = ver.students.find(:first, :conditions => ['student_number=?',row[:student_number]])
          if s
            student_attrs = { :pub_waiver_public => row[:pub_waiver_public],
              :pub_waiver_restricted => row[:pub_waiver_restricted] }
            # oops. forgot that pub_waiver fields are "yes" or "no" in PowerSchool
            # need to convert them to true or false
            bool_convert(student_attrs, :pub_waiver_public)
            bool_convert(student_attrs, :pub_waiver_restricted)
            s.update_attributes(student_attrs)
          else
            puts "not found!"
          end
        end
      end
    end
    
    # The file students.txt is created with Names-Families-All-Contact-Info 
    # export template.
    def import(ver=nil, fname='students.txt', options={})
      options = { :students_only => false, :col_sep => "\t", :row_sep => "\n" }.update(options)
      s_count = 0
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0,1] == '/'
      UnquotedCSV.foreach(fname, 
        :col_sep => options[:col_sep], :row_sep => options[:row_sep],
        :headers => true, :header_converters => :symbol) do |row|
        begin
          attrs = row.to_hash
          attrs[:home_id] = 0 if attrs[:home_id].nil?
          if attrs[:home_id].to_i == 0
            puts "no primary family for student #{row[:student_number]}"
            next
          end
          sid = attrs[:schoolid]
          if sid != '104' && sid != '103'
            puts "invalid school for student #{row[:student_number]}"
            next
          end
          attrs[:home2_id] = 0 if attrs[:home2_id].nil?
          puts "new student #{row[:student_number]}"
          student_attrs = attrs.reject { |k, v| !Student.has_attribute?(k) }
          # oops. forgot that pub_waiver fields are "yes" or "no" in PowerSchool
          # need to convert them to true or false
          bool_convert(student_attrs, :pub_waiver_public)
          bool_convert(student_attrs, :pub_waiver_restricted)
          if ver.nil?
            ver = Version.create
          elsif ver.is_a?(Fixnum)
            ver = Version.find(ver)
          end
          s = ver.students.build(student_attrs)
          s.save
          if !options[:students_only]
            if s.home_id != 0
              family = s.add_to_family(s.home_id, true,
                attrs[:web_id], 
                attrs[:web_password],
                attrs[:street], attrs[:city], attrs[:state], attrs[:zip],
                attrs[:mailing_street], attrs[:mailing_city], attrs[:mailing_state], attrs[:mailing_zip],
                attrs[:home_phone]) 
              s.add_parent(family.id, 'h1_p1', attrs[:mother_staff_id],
                attrs[:mother], attrs[:mother_first],
                [ attrs[:mother_email], attrs[:mother_email2] ],
                { :home => attrs[:mother_home_phone],
                  :work => attrs[:mother_work_phone],
                  :cell => attrs[:mother_cell_phone] })
              s.add_parent(family.id, 'h1_p2', attrs[:father_staff_id],
                attrs[:father], attrs[:father_first],
                [ attrs[:father_email], attrs[:father_email2] ],
                { :home => attrs[:father_home_phone],
                  :work => attrs[:father_work_phone],
                  :cell => attrs[:father_cell_phone] })
            end
            if s.home2_id != 0
              family = s.add_to_family(s.home2_id, false,
                attrs[:web_id], 
                attrs[:web_password],
                attrs[:home2_street], attrs[:home2_city], attrs[:home2_state], attrs[:home2_zip],
                attrs[:mailing2_street], attrs[:mailing2_city], attrs[:mailing2_state], attrs[:mailing2_zip],
                attrs[:home2_phone]) 
              s.add_parent(family.id, 'h2_p1', attrs[:mother2_staff_id],
                attrs[:mother2_last], attrs[:mother2_first],
                [ attrs[:mother2_email], attrs[:mother2_email2] ],
                { :home => attrs[:mother2_home_phone],
                  :work => attrs[:mother2_work_phone],
                  :cell => attrs[:mother2_cell_phone] })
              s.add_parent(family.id, 'h2_p2', attrs[:father2_staff_id],
                attrs[:father2_last], attrs[:father2_first], 
                [ attrs[:father2_email], attrs[:father2_email2] ],
                { :home => attrs[:father2_home_phone],
                  :work => attrs[:father2_work_phone],
                  :cell => attrs[:father2_cell_phone] })
            end
          end
          s.add_user
          s_count += 1
          # break if s_count == 20
        rescue
          raise
        end
      end
      
      # update last names for directory
      puts "rebuilding last names for directory..."
      Family.rebuild_last_names(ver)
      
      # this must be run *after* staff and student usernames are recorded
      puts "adding parent schoolwires users..."
      ver.parents.each do |par| 
        par.add_user
      end
      Parent.rebuild_user_roles(ver)
      
      # return the version id
      ver.id
    end
    
    def homeroom_password_letters(ver=nil, coll=nil, fname='letters.pdf')
      if coll.nil?
        ver = Version.current if ver.nil?
        coll = ver.students
      end
      hr_families = { }
      coll.each do |s|
        hr = s.home_room
        s.families.each { |f| (hr_families[hr] ||= []).push([f.id, f.last_name]) }
      end
      
      pdf = Prawn::Document.new(
        :left_margin => 72,
        :right_margin => 72,
        :top_margin => 72,
        :bottom_margin => 72,
        :skip_page_creation => true)
      home_rooms = hr_families.keys.sort
      home_rooms.each do |hr|
        p hr_families[hr]
        families = hr_families[hr].sort { |a, b| a[1] <=> b[1] }
        families.each do |fam|
          f = Family.find(fam[0])
          f.password_letter(pdf, true, "Room #{hr}")
        end
      end
      
      pdf.render_file(fname)
    end
    
    def report_text_fields(coll = nil)
      columns = [[:allergies, 450], 
        [:behavior_issues, 125], 
        [:movement_limits_desc, 125], 
        [:medical_considerations, 450],
        [:illness_desc, 450],
        [:medical_accom_desc, 450]]
      report = columns.inject({}) do |h, col|
        col_name = col[0]
        h[col_name] = { :student => nil, :max_length => nil, :text => nil,
          :overs => [ ],
          :buckets => [[ 450,  0 ], [ 300,  0], [ 150, 0 ], [ 100, 0 ]] }
        h
      end
      coll = Student.all if coll == nil
      coll.each do |stu|
        columns.each do |col|
          col_name = col[0]
          t = stu.send(col_name)
          if !t.blank?
            len = t.size
            report[col_name][:buckets].each_with_index do |bucket, i|
              if len >= bucket[0]
                report[col_name][:buckets][i][1] += 1
                break
              end
            end
            col_max = col[1]
            if len > col_max
              first = t[0,col_max]
              last = t[col_max,len-col_max]
              report[col_name][:overs] << { :student => stu.to_s, :text => "#{first}<<<\n>>>#{last}"}
            end
            max_len = report[col_name][:max_length]
            if max_len.nil? || len > max_len
              report[col_name][:student] = stu.to_s
              report[col_name][:max_length] = len
              report[col_name][:text] = t 
            end
          end
        end
      end
      columns.each do |col|
        col_name = col[0]
        puts col_name.to_s
        report[col_name][:buckets].each do |bucket|
          puts " >= #{bucket[0]}: #{bucket[1]}"
        end
        puts " student: #{report[col_name][:student]}"
        puts " length:  #{report[col_name][:max_length]}"
        if report[col_name][:overs].size
          puts " #{report[col_name][:overs].size} overs:"
          report[col_name][:overs].each do |h|
            puts "   student: #{h[:student]}"
            puts "   text:    #{h[:text]}"
            print "\n"
          end
        end
        print "\n\n"
      end
    end
  end
end
