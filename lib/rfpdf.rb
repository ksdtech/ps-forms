require 'fpdf'
require 'field_options'

class RegFormPDF < FPDF
  attr_accessor :line_y, :font_height, :chkbox_size, :leading, :txtbox_width, :q_nil
  MAX_FIELD_LENGTH_1 = 125
  MAX_FIELD_LENGTH_3 = 450
  
  class << self
    def missing_data(filename=nil)
      students = Student.find(:all, :conditions => 
        ["state_studentnumber IS NULL and (dob = '1901-01-01' or ethnicity IS NULL or ca_homelanguage IS NULL)" ])
      return RegFormPDF.new(filename).output_missing_data(students)
    end
    
    def reg_forms(students, filename=nil, blanks=false)
      return RegFormPDF.new(filename, true, false, blanks).output_reg_forms(students)
    end
        
    def emergency_forms(students, filename=nil, blanks=false)
      return RegFormPDF.new(filename, false, true, blanks).output_emergency_forms(students)
    end
        
    def all_forms(students, filename=nil)
      return RegFormPDF.new(filename).output_all_forms(students)
    end   
    
    def export_bacich_reg_forms(basename, ver=nil, order=nil)
      export_forms(basename, ver, order, 103, true, false, 'output_reg_forms')
    end

    def export_kent_reg_forms(basename, ver=nil, order=nil)
      export_forms(basename, ver, order, 104, true, false, 'output_reg_forms')
    end
    
    def export_bacich_emergency_forms(basename, ver=nil, order="home_room,last_name,first_name")
      export_forms(basename, ver, order, 103, false, true, 'output_emergency_forms')
    end

    def export_kent_emergency_forms(basename, ver=nil, order="grade_level,last_name,first_name")
      export_forms(basename, ver, order, 104, false, true, 'output_emergency_forms')
    end

    def export_forms(basename, ver, order, school_id, reg_forms, emergency_forms, method, conds=nil)
      ver = Version.current if ver.nil?
      order = 'last_name,first_name' if order.blank?
      conds ||= [ 'enroll_status<=0 AND schoolid=?', school_id ]
      slice_start = 0
      slice_len = 100
      st_slice = ver.students.find(:all, :conditions => conds,
        :order => order, :offset => slice_start, :limit => slice_len)
      while !st_slice.empty?
        fname = sprintf("%s-%04d.pdf", basename, slice_start)
        RegFormPDF.new(fname, reg_forms, emergency_forms).send(method, st_slice)
        slice_start += slice_len
        st_slice = ver.students.find(:all, :conditions => conds,
          :order => order, :offset => slice_start, :limit => slice_len)
      end
    end
  end

  def fmt_select(options, val)
    return @q_nil if val.nil?
    options.each do |opt|
      return opt[0] if opt[1] == val
    end
    return @q_nil
  end
  
  def fmt_date(val)
    return @q_nil if val.nil?
    return val if !val.respond_to?(:month)
    "#{val.month}/#{val.day}/#{val.year}"
  end
  
  def initialize(filename=nil, reg_forms=true, emergency_forms=true, blanks=false)
    @q_nil = '' # or '?'
    @file = filename
    @rffonts = reg_forms
    @effonts = emergency_forms
    @blank_checkboxes = blanks
    super('P', 'pt', 'letter', File.dirname(__FILE__))
    SetCompression(false)
    SetMargins(36, 36)
    if reg_forms or emergency_forms
      AddFont('ArialNarrow', '',  'arialn.rb')
      AddFont('ArialNarrow', 'B', 'arialnb.rb')
    end
    if emergency_forms
      AddFont('TrebuchetMS', '',  'trebuc.rb')
      AddFont('TrebuchetMS', 'B', 'trebucbd.rb')
      AddFont('TrebuchetMS', 'I', 'trebucit.rb')
    end
  end
  
  def output_missing_data(students)
    for student in  students
      missing_data(student)
    end 
    self.Output(@file)
  end
  
  def output_reg_forms(students)
    for student in  students
      reg_form_page_1(student)
      reg_form_page_2(student)
      reg_form_page_3(student)
      reg_form_page_4(student)
    end 
    self.Output(@file)
  end
  
  def output_emergency_forms(students)
    for student in students
      emergency_form_page_1(student)
      emergency_form_page_2(student)
    end 
    self.Output(@file)
  end
  
  def output_all_forms(students)
    for student in students
      reg_form_page_1(student)
      reg_form_page_2(student)
      reg_form_page_3(student)
      reg_form_page_4(student)
      emergency_form_page_1(student)
      emergency_form_page_2(student)
    end 
    self.Output(@file)
  end
  
  protected
      
  def set_reg_form_params
    if !@rffonts
      raise "need to specify reg_forms fonts"
    end
    @cMargin = 0
    @chkbox_size = 9
    @font_height = 11
    @leading = 13  # for paragraphs in txa()
    @line_spacing = 18 # for newline()
    @txtbox_height = @font_height + 4
    @txtbox_width = 100
    @font_styles = [
      [ 'ArialNarrow', '', @font_height ],  # 1: default
      [ 'ArialNarrow', 'B', @font_height ], # 2: bold for field data
      [ 'ArialNarrow', 'B', 14, 210.0 ], # 3: section headings, etc.
      [ 'ArialNarrow', '', 7 ], # 4:  fine print
    ]
  end

  def set_emergency_form_params
    if !@effonts
      raise "need to specify emergency_forms fonts"
    end
    @cMargin = 0
    @chkbox_size = 7
    @font_height = 9.5
    @leading = 11  # for paragraphs in txa()
    @line_spacing = 12.5 # for newline()
    @txtbox_height = @font_height + 1
    @txtbox_width = 100
    @font_styles = [
      [ 'TrebuchetMS', '', @font_height ],  # 1: default
      [ 'ArialNarrow', 'B', @font_height ], # 2: bold for field data
      [ 'TrebuchetMS', '', 11, 0 ], # 3: section headings, etc.
      [ 'TrebuchetMS', 'I', 8 ], # 4:  fine print
      [ 'TrebuchetMS', 'B', 14 ], # 5: card titles
      [ 'TrebuchetMS', '', 9 ],  # 6: teensy bit smaller
    ]
  end
  
  def set_font(style_num)
    if !@font_styles.nil? && @font_styles.size > 0
      if style_num < 1 || style_num > @font_styles.size
        style_num = 1
      end
      style_num -= 1
      family, style, height, gray = @font_styles[style_num]
      SetFont(family, style, height)
      gray = 255.0 if gray.nil?
      if gray == 0
        SetTextColor(255.0)
      else
        SetTextColor(0)
      end
      SetFillColor(gray)
      return leading
    end
    @leading
  end
  
  def newline_at(y)
    @line_y = y
  end

  def newline(dy=nil)
    dy = @line_spacing if dy.nil?
    @line_y += dy
  end
  
  def banner_at(y, text, x=nil, w=nil)
    @line_y = y
    h = set_font(3)
    x = @lMargin if x.nil?
    if w.nil?
      w = @w-@rMargin-x
    elsif w < 0
      w = GetStringWidth(text)+8
    end
    Rect(x, y+2, w, -h, 'F')
    Text(x+4, y, text)
  end
  
  def txt(x, text, style_num=1, y=nil)
    y = @line_y if y.nil?
    set_font(style_num)
    Text(x, y, text)
  end
  
  def txa(x, w, text, style_num=1, advance=false, align='L', h=nil, y=nil)
    h = @leading if h.nil?
    y = @line_y if y.nil?
    SetXY(x, y)
    set_font(style_num)
    MultiCell(w, h, text, 0, align)
    @line_y = @y if advance
  end

  def tbx(x, text, w=nil, h=nil, y=nil)
    w = @txtbox_width if w.nil?
    h = @txtbox_height if h.nil?
    y = @line_y if y.nil?
    SetDrawColor(0.0, 105.0, 255.0)
    SetLineWidth(0.4)
    Rect(x, y + 2 - @txtbox_height, w, h)
    # still don't know why the parens are escaped sometimes
    text = text.to_s.gsub(/\<BR\>/i, "\n").gsub(/\\\(/, '(').gsub(/\\\)/, ')')
    next_y = @line_y
    SetXY(x + 2, y + 2 - @leading)
    
    set_font(2)
    MultiCell(w - 4, @leading, text, 0, 'L')
    @line_y = next_y
  end

  def lin(x1, y1, x2, y2)
    SetDrawColor(0.0)
    SetLineWidth(1)
    Line(x1, y1, x2, y2)
  end
  
  def cbx(x, checked, prompt='', size=nil, y=nil)
    size = @chkbox_size if size.nil?
    y = @line_y if y.nil?
    SetDrawColor(0.0)
    SetLineWidth(1)
    Rect(x, y, size, -size)
    if !@blank_checkboxes && checked
      SetLineWidth(0.4)
      Line(x, y, x+size, y-size)
      Line(x, y-size, x+size, y)
    end
    if !prompt.empty?
      set_font(1)
      Text(x+size+4, y, prompt)
    end
  end
    
  def cbx_test(x, field, value, prompt='', size=nil, y=nil)
    if field.nil? || !field
      field = '0'
    elsif field === true
      field = '1'
    else
      field = field.to_s.strip
      field = '0' if field.empty?
    end
    checked = (field.downcase == value.downcase)
    cbx(x, checked, prompt, size, y)
  end
    
  def reg_form_header(student)
    banner_at(50, "Kentfield School District Registraton Form for #{student.reg_year} School Year")
    newline_at(72)
    txt(40, "Student's name")
    txt(114, 'Last')
    tbx(136, student.last_name)
    txt(244, 'First')
    tbx(266, student.first_name)
    txt(372, 'Middle')
    tbx(406, student.middle_name)
    txt(516, 'Grade')
    tbx(552, fmt_select(SHORT_GRADE_LEVEL_OPTIONS, student.grade_level), 24)   
  end
    
  def reg_form_footer
    newline_at(744)
    txt(454, 'Form continues on next page')
  end 
  
  def reg_form_end_footer
    newline_at(744)
    txt(40, 'End of this form.  Please make sure to provide all required information on Emergency Contact Card.')
  end 
  
    def new_page(student, orientation='', rotation=0)
    AddPage(orientation, rotation)
    #if !@file.nil?
    # print "printing #{student.student_number}, page #{@page}\n"
    #end
  end
  
  def missing_data(student)
    set_reg_form_params
    new_page(student, 'P')
    # header
    banner_at(50, "Kentfield School District Registraton Form for #{student.reg_year} School Year")
    newline_at(132)
    txt(316, 'Grade level')
    tbx(552, fmt_select(SHORT_GRADE_LEVEL_OPTIONS, student.grade_level), 24)   
    # student info
    banner_at(156, 'Student Identification')
    newline_at(172)
    txt(40, "Student's legal name as it appears on birth certificate or passport.")
    newline
    txt(40, 'Last')
    tbx(62, student.last_name)
    txt(176, 'First')
    tbx(198, student.first_name)
    txt(324, 'Middle')
    tbx(354, student.middle_name)
    newline
    style = 1
    dob_txt = fmt_date(student.dob)
    if student.dob < Date.new(1988, 1, 1)
      style = 2
      dob_txt = ''
    end
    txt(40, "Date of Birth", style)
    tbx(94, dob_txt)
    txt(216, "Gender")
    cbx_test(254, student.gender, 'M', 'M')
    cbx_test(280, student.gender, 'F', 'F')
    newline
    style = 1
    if student.ca_birthplace_city.nil?
      style = 2
    end
    txt(40, "Student's birth place", style)
    txt(138, "City")
    tbx(160, student.ca_birthplace_city)
    txt(276, "State")
    tbx(300, student.ca_birthplace_state)
    txt(416, "Country")
    tbx(450, fmt_select(COUNTRY_OPTIONS, student.ca_birthplace_country), 126)
    # ethnicity
    banner_at(260, 'State-Required Demographics: Ethnicity')
    newline_at(276)
    banner_at(500, 'English Language Proficiency')
    newline_at(516)
    style = 1
    if student.ca_homelanguage.nil?
      style = 2
    end
    txt(40, 'Primary language spoken at home by student', style)
    tbx(234, fmt_select(LANGUAGE_OPTIONS, student.ca_homelanguage), 144)
    cbx_test(390, student.ca_langfluency, '1', 'English is only language spoken')    
    newline
    txt(40, 'Other language spoken at home')
    tbx(234, fmt_select(LANGUAGE_OPTIONS, student.lang_other), 144)
  end
  
  def reg_form_page_1(student)
    set_reg_form_params
    new_page(student, 'P')
    # header
    banner_at(50, "Kentfield School District Registraton Form for #{student.reg_year} School Year")
    newline_at(100)
    txt(316, "Grade level that student will be entering in August #{student.short_reg_year}")
    tbx(552, fmt_select(SHORT_GRADE_LEVEL_OPTIONS, student.grade_level), 24)   
    # student info
    banner_at(124, '1. Student Identification')
    newline_at(140)
    txt(40, "Student's legal name as it appears on birth certificate or passport.")
    newline
    txt(40, 'Last')
    tbx(62, student.last_name)
    txt(176, 'First')
    tbx(198, student.first_name)
    txt(324, 'Middle')
    tbx(354, student.middle_name)
    banner_at(180, '2a. Name and Birth Information')
    newline_at(200)
    txt(40, "Student's suffix if applicable")
    tbx(160, student.ca_namesuffix)
    txt(312, "Student's nickname if applicable")
    tbx(450, student.nickname, 126)
    newline
    txt(40, "Date of Birth")
    tbx(94, fmt_date(student.dob))
    txt(216, "Gender")
    cbx_test(254, student.gender, 'M', 'M')
    cbx_test(280, student.gender, 'F', 'F')
    newline
    txt(40, "Student's birth place:")
    txt(138, "City")
    tbx(160, student.ca_birthplace_city)
    txt(276, "State")
    tbx(300, student.ca_birthplace_state)
    txt(416, "Country")
    tbx(450, fmt_select(COUNTRY_OPTIONS, student.ca_birthplace_country), 126)
    banner_at(256, '2b. (Custody Information - See Emergency Card)')   
    banner_at(272, '2c. (Siblings - See Next Page of This Form)')   
    
    # residence
    banner_at(288, '3a. Qualifying Residence')    
    newline_at(304)
    txt(40, 'Physical (street) address of qualifying residence. This address must be within the school district boundary.')
    newline
    txt(40, 'Address')
    tbx(86, student.street, 188)
    txt(280, 'City')
    tbx(308, student.city, 84)
    txt(400, 'State')
    tbx(426, student.state, 36)
    txt(470, 'Zip')
    tbx(492, student.zip, 84)
    newline
    txt(40, 'Mailing address if different.')
    newline
    txt(40, 'Address')
    tbx(86, student.mailing_street, 188)
    txt(280, 'City')
    tbx(308, student.mailing_city, 84)
    txt(400, 'State')
    tbx(426, student.mailing_state, 36)
    txt(470, 'Zip')
    tbx(492, student.mailing_zip, 84)
    newline
    txt(40, 'Phone numbers for this residence:')
    txt(190, 'Main number')
    tbx(262, student.home_phone, 114)
    # txt(390, "Student's phone")
    # tbx(462, student.student_phone, 114)
    newline
    cbx(40, student.home_no_inet_access, 'No internet access at this residence')
    newline
    cbx(40, student.home_printed_material, 'We request printed school communications')
    cbx(280, student.home_spanish_material, 'We request Spanish language school communications')
    # parent1
    banner_at(432, '3b. Mother/Parent/Guardian at Qualifying Residence')   
    newline_at(448)
    txt(40, "Parent's name and legal status.")
    newline
    txt(40, 'Last')
    tbx(62, student.mother)
    txt(176, 'First')
    tbx(198, student.mother_first)
    txt(314, "Is this parent student's legal guardian?")
    cbx(480, student.mother_isguardian, 'Yes')
    cbx_test(520, student.mother_isguardian, '0', 'No')
    newline
    txt(40, "Parent's relationship to student")
    cbx_test(178, student.mother_rel, 'mother', 'Mother')
    cbx_test(232, student.mother_rel, 'stepmother', 'Stepmother')
    cbx_test(300, student.mother_rel, 'grandmother', 'Grandmother')
    cbx_test(374, student.mother_rel, 'aunt', 'Aunt')
    cbx_test(418, student.mother_rel, 'guardian', 'Guardian')
    newline(16)
    cbx_test(178, student.mother_rel, 'father', 'Father')
    cbx_test(232, student.mother_rel, 'stepfather', 'Stepfather')
    cbx_test(300, student.mother_rel, 'grandfather', 'Grandfather')
    cbx_test(374, student.mother_rel, 'uncle', 'Uncle')
    cbx_test(418, student.mother_rel, 'other', 'Other')
    newline
    txt(40, "Parent phone numbers:")
    txt(178, 'Work phone')
    tbx(232, student.mother_work_phone, 114)
    txt(400, 'Home phone')
    tbx(462, student.mother_home_phone, 114)
    newline
    txt(178, 'Cell phone')
    tbx(232, student.mother_cell, 114)
    txt(400, 'Pager')
    tbx(462, student.mother_pager, 114)
    newline
    txt(40, "Email address for District communications")
    tbx(232, student.mother_email, 344)
    newline
    txt(40, "Parent's employer name and city:")
    txt(190, 'Employer')
    tbx(232, student.mother_employer, 204)
    txt(450, 'City')
    tbx(470, student.mother_employer_address, 106)
    # parent2
    banner_at(592, '3c. Father/Parent/Guardian at Qualifying Residence')   
    newline_at(608)
    txt(40, "Parent's name and legal status.")
    newline
    txt(40, 'Last')
    tbx(62, student.father)
    txt(176, 'First')
    tbx(198, student.father_first)
    txt(314, "Is this parent student's legal guardian?")
    cbx(480, student.father_isguardian, 'Yes')
    cbx_test(520, student.father_isguardian, '0', 'No')
    newline
    txt(40, "Parent's relationship to student")
    cbx_test(178, student.father_rel, 'mother', 'Mother')
    cbx_test(232, student.father_rel, 'stepmother', 'Stepmother')
    cbx_test(300, student.father_rel, 'grandmother', 'Grandmother')
    cbx_test(374, student.father_rel, 'aunt', 'Aunt')
    cbx_test(418, student.father_rel, 'guardian', 'Guardian')
    newline(16)
    cbx_test(178, student.father_rel, 'father', 'Father')
    cbx_test(232, student.father_rel, 'stepfather', 'Stepfather')
    cbx_test(300, student.father_rel, 'grandfather', 'Grandfather')
    cbx_test(374, student.father_rel, 'uncle', 'Uncle')
    cbx_test(418, student.father_rel, 'other', 'Other')
    newline
    txt(40, "Parent phone numbers:")
    txt(178, 'Work phone')
    tbx(232, student.father_work_phone, 114)
    txt(400, 'Home phone')
    tbx(462, student.father_home_phone, 114)
    newline
    txt(178, 'Cell phone')
    tbx(232, student.father_cell, 114)
    txt(400, 'Pager')
    tbx(462, student.father_pager, 114)
    newline
    txt(40, "Email address for District communications")
    tbx(232, student.father_email, 344)
    newline
    txt(40, "Parent's employer name and city:")
    txt(190, 'Employer')
    tbx(232, student.father_employer, 204)
    txt(450, 'City')
    tbx(470, student.father_employer_address, 106)
    # footer
    reg_form_footer
  end
    
  def reg_form_page_2(student)
    new_page(student, 'P')
    # header
    reg_form_header(student)
    # siblings
    banner_at(100, '2c. Siblings')
    newline_at(116)
    txt(40, 'For planning purposes, please list the names and birthdates of any siblings who may enter Bacich or Kent in future years.')
    newline
    txt(40, 'First Name')
    tbx(100, student.sibling1_name)
    txt(250, 'Date of Birth')
    tbx(310, fmt_date(student.sibling1_dob))
    newline
    txt(40, 'First Name')
    tbx(100, student.sibling2_name)
    txt(250, 'Date of Birth')
    tbx(310, fmt_date(student.sibling2_dob))
    newline
    txt(40, 'First Name')
    tbx(100, student.sibling3_name)
    txt(250, 'Date of Birth')
    tbx(310, fmt_date(student.sibling3_dob))
    newline
    txt(40, 'First Name')
    tbx(100, student.sibling4_name)
    txt(250, 'Date of Birth')
    tbx(310, fmt_date(student.sibling4_dob))
    # residence
    newline_at(216)
    txt(40, 'If the next section does not apply, go on to the next page.  Report cards and other correspondance will also be sent to this address.')
    banner_at(232, '4a. Additional Residence')
    newline_at(248)
    txt(40, 'Physical (street) address of additional residence.')
    newline
    txt(40, 'Address')
    tbx(86, student.home2_street, 188)
    txt(280, 'City')
    tbx(308, student.home2_city, 84)
    txt(400, 'State')
    tbx(426, student.home2_state, 36)
    txt(470, 'Zip')
    tbx(492, student.home2_zip, 84)
    newline
    txt(40, 'Mailing address if different.')
    newline
    txt(40, 'Address')
    tbx(86, student.mailing2_street, 188)
    txt(280, 'City')
    tbx(308, student.mailing2_city, 84)
    txt(400, 'State')
    tbx(426, student.mailing2_state, 36)
    txt(470, 'Zip')
    tbx(492, student.mailing2_zip, 84)
    newline
    txt(40, 'Phone numbers for this residence:')
    txt(190, 'Main number')
    tbx(262, student.home2_phone, 114)
    # txt(390, "Student's phone")
    # tbx(462, student.home2_student_phone, 114)
    newline
    cbx(40, student.home2_no_inet_access, 'No internet access at this residence')
    newline
    cbx(40, student.home2_printed_material, 'We request printed school communications')
    cbx(280, student.home2_spanish_material, 'We request Spanish language school communications')
    # parent1
    banner_at(376, '4b. Mother/Parent/Guardian at Additional Residence')   
    newline_at(392)
    txt(40, "Parent's name and legal status.")
    newline
    txt(40, 'Last')
    tbx(62, student.mother2_last)
    txt(176, 'First')
    tbx(198, student.mother2_first)
    txt(314, "Is this parent student's legal guardian?")
    cbx(480, student.mother2_isguardian, 'Yes')
    cbx_test(520, student.mother2_isguardian, '0', 'No')
    newline
    txt(40, "Parent's relationship to student")
    cbx_test(178, student.mother2_rel, 'mother', 'Mother')
    cbx_test(232, student.mother2_rel, 'stepmother', 'Stepmother')
    cbx_test(300, student.mother2_rel, 'grandmother', 'Grandmother')
    cbx_test(374, student.mother2_rel, 'aunt', 'Aunt')
    cbx_test(418, student.mother2_rel, 'guardian', 'Guardian')
    newline(16)
    cbx_test(178, student.mother2_rel, 'father', 'Father')
    cbx_test(232, student.mother2_rel, 'stepfather', 'Stepfather')
    cbx_test(300, student.mother2_rel, 'grandfather', 'Grandfather')
    cbx_test(374, student.mother2_rel, 'uncle', 'Uncle')
    cbx_test(418, student.mother2_rel, 'other', 'Other')
    newline
    txt(40, "Parent phone numbers:")
    txt(178, 'Work phone')
    tbx(232, student.mother2_work_phone, 114)
    txt(400, 'Home phone')
    tbx(462, student.mother2_home_phone, 114)
    newline
    txt(178, 'Cell phone')
    tbx(232, student.mother2_cell, 114)
    txt(400, 'Pager')
    tbx(462, student.mother2_pager, 114)
    newline
    txt(40, "Email address for District communications")
    tbx(232, student.mother2_email, 344)
    newline
    txt(40, "Parent's employer name and city:")
    txt(190, 'Employer')
    tbx(232, student.mother2_employer, 204)
    txt(450, 'City')
    tbx(470, student.mother2_employer_address, 106)
    # parent2
    banner_at(536, '4c. Father/Parent/Guardian at Additional Residence')   
    newline_at(552)
    txt(40, "Parent's name and legal status.")
    newline
    txt(40, 'Last')
    tbx(62, student.father2_last)
    txt(176, 'First')
    tbx(198, student.father2_first)
    txt(314, "Is this parent student's legal guardian?")
    cbx(480, student.father2_isguardian, 'Yes')
    cbx_test(520, student.father2_isguardian, '0', 'No')
    newline
    txt(40, "Parent's relationship to student")
    cbx_test(178, student.father2_rel, 'mother', 'Mother')
    cbx_test(232, student.father2_rel, 'stepmother', 'Stepmother')
    cbx_test(300, student.father2_rel, 'grandmother', 'Grandmother')
    cbx_test(374, student.father2_rel, 'aunt', 'Aunt')
    cbx_test(418, student.father2_rel, 'guardian', 'Guardian')
    newline(16)
    cbx_test(178, student.father2_rel, 'father', 'Father')
    cbx_test(232, student.father2_rel, 'stepfather', 'Stepfather')
    cbx_test(300, student.father2_rel, 'grandfather', 'Grandfather')
    cbx_test(374, student.father2_rel, 'uncle', 'Uncle')
    cbx_test(418, student.father2_rel, 'other', 'Other')
    newline
    txt(40, "Parent phone numbers:")
    txt(178, 'Work phone')
    tbx(232, student.father2_work_phone, 114)
    txt(400, 'Home phone')
    tbx(462, student.father2_home_phone, 114)
    newline
    txt(178, 'Cell phone')
    tbx(232, student.father2_cell, 114)
    txt(400, 'Pager')
    tbx(462, student.father2_pager, 114)
    newline
    txt(40, "Email address for District communications")
    tbx(232, student.father2_email, 344)
    newline
    txt(40, "Parent's employer name and city:")
    txt(190, 'Employer')
    tbx(232, student.father2_employer, 204)
    txt(450, 'City')
    tbx(470, student.father2_employer_address, 106)
    # parent2
    # footer
    reg_form_footer
  end
      
  def reg_form_page_3(student)
    new_page(student, 'P')
    # header
    reg_form_header(student)
    banner_at(100, '5. (Emergency Contacts - See Emergency Card)')   
    # prev school
    banner_at(116, '6a. Previous School Enrollment')   
    newline_at(132)
    txt(40, "Please provide information about the last school attended, if any, and sign the permission in section 9a. of this form.")
    newline
    txt(40, 'Name')
    tbx(66, student.previous_school_name)
    txt(204, 'Street')
    tbx(234, student.previous_school_address)
    txt(458, 'City')
    tbx(476, student.previous_school_city)
    newline
    txt(40, 'School phone number and highest grade level achieved:')
    txt(270, 'Phone')
    tbx(318, student.previous_school_phone)
    txt(446, 'Grade')
    tbx(476, student.previous_school_grade_level)
    newline
    txt(40, 'Date student was first enrolled in a K-8 U.S. school')
    tbx(258, fmt_date(student.ca_firstusaschooling))
    txt(372, 'In a K-8 California school')
    tbx(476, fmt_date(student.schoolentrydate_ca))
    # programs
    # banner_at(228, '5. Other Programs')
    # newline_at(244)
    # txt(40, 'If the student is expected to be enrolled in any of these programs, check the appropriate boxes so that the school office may contact you.')
    # newline
    # cbx(40, student.prog_504, 'Section 504') 
    # cbx(140, student.prog_rsp, 'Resource Special Program')   
    # cbx(294, student.prog_eld, 'English Language Learning Program')   
    # ethnicity
    banner_at(208, '6b. State-Required Demographics: Ethnicity and Race')
    newline_at(224)
    txt(40, "What is your child's ethnicity? Please check one of the two choices below:")
    newline
    cbx(40, student.ca_ethnla, 'Hispanic or Latino')    
    cbx(156, student.ca_ethnla === false, 'Not Hispanic or Latino')   
    newline(12)
    txa(40, 520, "The previous question is about ethnicity, not race.  No matter what you selected above, please continue to answer the following by marking one or more boxes to indicate what you consider your child's racial makeup to be.", 1, true, 'L')
    newline(12)
    txt(40, "What is your child's race? Please check up to five categories from the list below:")
    newline
    cbx(40, student.ca_ethnaa, 'African American or Black')    
    cbx(216, student.ca_ethnaspich, 'Chinese')    
    cbx(332, student.ca_ethnaspila, 'Laotian')
    cbx(448, student.ca_ethnaspiha, 'Hawaiian')
    newline(16)
    cbx(40, student.ca_ethnai, 'American Indian or Alaskan Native')    
    cbx(216, student.ca_ethnaspija, 'Japanese')    
    cbx(332, student.ca_ethnaspica, 'Cambodian')    
    cbx(448, student.ca_ethnaspigu, 'Guamanian')    
    newline(16)
    cbx(40, student.ca_ethnfi, 'Filipino or Filipino American') 
    cbx(216, student.ca_ethnaspiko, 'Korean')    
    cbx(332, student.ca_ethnhm, 'Hmong')    
    cbx(448, student.ca_ethnaspisa, 'Samoan')    
    newline(16)
    cbx(40, student.ca_ethnwh, 'White')
    cbx(216, student.ca_ethnaspivi, 'Vietnamese')    
    cbx(332, student.ca_ethnaspioa, 'Other Asian')    
    cbx(448, student.ca_ethnaspita, 'Tahitian')    
    newline(16)
    cbx(216, student.ca_ethnaspiai, 'Asian Indian')    
    cbx(448, student.ca_ethnaspiopi, 'Other Pacific Islander')    
    newline(16)
    # parent education
    banner_at(408, '6c. State-Required Demographics: Parent Educational Level')
    newline_at(424)
    txt(40, "Check the box corresponding to the highest educational level achieved by any of the student's parents.")
    newline
    cbx_test(40, student.ca_parented, '14', 'Not a high school graduate')   
    cbx_test(186, student.ca_parented, '12', 'Some college (includes AA degree)')   
    cbx_test(368, student.ca_parented, '10', 'Graduate school')   
    newline(16)
    cbx_test(40, student.ca_parented, '13', 'High school graduate')   
    cbx_test(186, student.ca_parented, '11', 'College graduate')    
    cbx_test(368, student.ca_parented, '15', 'Unknown or decline to state')
    # lang survey
    banner_at(480, '7. Home Language Survey')
    newline(6)
    txa(40, 520, 'The California Education Code requires schools to determine the language(s) spoken in the home of each student.  Please answer all of the questions in this section.', 1, true, 'L')
    newline(12)
    txt(40, '7a. Which langugage did this student learn when he or she first began to talk?')
    tbx(430, fmt_select(LANGUAGE_OPTIONS, student.lang_earliest), 144)
    newline
    txt(40, '7b. What language does this student most frequently use at home?')
    tbx(430, fmt_select(LANGUAGE_OPTIONS, student.ca_homelanguage), 144)
    newline
    txt(40, '7c. What language do you use most frequently to speak to this student?')
    tbx(430, fmt_select(LANGUAGE_OPTIONS, student.lang_spoken_to), 144)
    newline
    txt(40, '7d. What language is most often spoken by the adults (parents, grandparents, others) at home?')
    tbx(430, fmt_select(LANGUAGE_OPTIONS, student.lang_adults_primary), 144)
    newline
    txt(40, '7e. If applicable, what other language is spoken by the adults at home?')
    tbx(430, fmt_select(LANGUAGE_OPTIONS, student.lang_other), 144)
    newline(20)
    txt(40, 'If applicable, enter date student was first enrolled in an English Language Development Program.')
    tbx(450, fmt_date(student.ca_dateenroll))
    newline
    txt(40, 'If the student was reclassified as Fluent-English Proficient, enter the date of reclassification.')
    tbx(450, fmt_date(student.ca_daterfep))
    # footer
    reg_form_footer
  end
  
  def reg_form_page_4(student)
    new_page(student, 'P')
    # header
    reg_form_header(student)
    # emergency
    banner_at(100, '8. (Medical Information - See Emergency Card)')
    # permissions
    banner_at(116, '9a. Previous School Permission')
    newline(6)
    txa(40, 520, "I hereby grant permission to the Kentfield School District to contact my child's previous school regarding recommendations for placement.", 1, true, 'L')
    newline_at(168)
    txa(40, 160, 'Parent(s) / Guardian(s) Signatures', 1, true, 'R')
    tbx(210, '', 160, @txtbox_height + @line_spacing)
    newline_at(168)
    txa(390, 40, 'Date', 1, true, 'R')
    tbx(440, '', 100)

    banner_at(200, '9b. (Emergency Authorization - See Emergency Card)')

    banner_at(216, '9c. Permission to Publish on the Public Internet')
    newline(6)
    txa(40, 520, 'Please review the Web Publishing Guidelines in the registration packet before answering questions 9c. and 9d.  The Guidelines are also available on our website at http://www.kentfieldschools.org/District/Technology.  You may opt to deny publication of school work created by, or pictures of, your child by checking the appropriate No box.', 1, true, 'L')
    txa(40, 520, 'Important: Check either the Yes box or the No box for each of questions 9c. and 9d.  If neither box is checked, or if both boxes are checked, the District will assume that you are allowing publication. ', 2, true, 'L')
    newline(6)
    txa(40, 520, 'I hereby grant or deny permission to the Kentfield School District to allow the publication of work created by my child, articles mentioning my child, or group photos containing images of my child, as described in the Web Publishing Guidelines, on the publicly accessible internet.', 1, true, 'L')
    newline(12)
    cbx(140, student.pub_waiver_public, 'Yes, allow publication')
    cbx(260, (student.pub_waiver_public === false), 'No, deny publication for Public Internet')
    cbx(564, student.pub_waiver_public.nil?)

    banner_at(372, '9d. Permission to Publish for Restricted Distribution')
    newline(6)
    txa(40, 520, 'I hereby grant or deny permission to the Kentfield School District to allow the publication of work created by my child, articles mentioning my child or other family members, or individual or group photos of my child or other family members, as described in the Web Publishing Guidelines, at school or district meetings, in documents, on CD and DVD disks, in e-mails, on web sites or on other media that are restricted to viewing by District staff, students and parents.', 1, true, 'L')
    newline(12)
    cbx(140, student.pub_waiver_restricted, 'Yes, allow publication')
    cbx(260, (student.pub_waiver_restricted === false), 'No, deny publication for Private Distribution')
    cbx(564, student.pub_waiver_restricted.nil?)
    
    banner_at(468, '9e. Responsibility for Student')
    newline(6)
    txa(40, 520, 'Sign and date the following agreement:  To the best of my knowledge, all the information reported on this form is true and correct.  I (we) assume full responsibility for my student in all school matters.  I (we) will notify the school office immediately if there is a change in any of the information reported on this form.', 1, true, 'L')

    newline_at(532)
    txa(40, 160, 'Parent(s) / Guardian(s) Signatures', 1, true, 'R')
    tbx(210, '', 160, @txtbox_height + @line_spacing)
    newline_at(532)
    txa(390, 40, 'Date', 1, true, 'R')
    tbx(440, '', 100)
    
    banner_at(572, '9f. (Emergency Volunteer Information - See Emergency Card')
    newline(6)
    txa(40, 520, 'Registration is not complete unless both sides of the Marin County Student Emergency Contact Card have been completely filled out and signed, and any legal custody and/or visitation orders have been submitted.', 2, true, 'L')

    # footer
    reg_form_end_footer
  end
  
  def emergency_form_page_1(student)
    set_emergency_form_params
    new_page(student, 'L', 90)
    newline_at(36)
    txa(36, 720, 'STUDENT EMERGENCY CONTACT CARD', 5, true, 'C')
    txa(36, 720, 'Emergency Contacts / Medical Consent (other side)', 2, false, 'C')
    # newline_at(72)
    # txa(162, 380, %{In case of an emergency, it is imperative that the school be able to reach the student's parent or guardian.  Please fill in the information on both sides of this card carefully and accurately.  Please type or use ink and print clearly and legibly.})
    newline_at(96)
    txt(548, 'Grade')
    tbx(580, fmt_select(SHORT_GRADE_LEVEL_OPTIONS, student.grade_level), 24)
    banner_at(124, 'STUDENT', 58, -1)
    tbx(120, student.last_name, 96)
    tbx(222, student.first_name, 96)
    tbx(324, student.middle_name, 96)
    cbx_test(450, student.gender, 'M', 'Male')
    newline
    txt(120, 'Last Name')
    txt(222, 'First')
    txt(324, 'Middle')
    cbx_test(450, student.gender, 'F', 'Female')
    newline_at(152)
    tbx(66, student.street, 150)
    tbx(222, student.city, 148)
    tbx(376, student.zip, 44)
    tbx(450, student.home_phone, 84)
    tbx(540, fmt_date(student.dob), 84)
    tbx(630, student.ca_birthplace_city, 100)
    newline
    txt(66, 'Home Address (Primary Residence)')
    txt(292, 'City')
    txt(376, 'State/Zip')
    txt(450, 'Home Phone')
    txt(540, 'Birthdate')
    txt(630, 'Birthplace')
    newline_at(180)
    tbx(66, student.mailing_street, 150)
    tbx(222, student.mailing_city, 148)
    tbx(376, student.mailing_zip, 44)
    txt(450, 'Lives with:')
    cbx_test(508, student.lives_with_rel, 'both', 'Both Parents')
    cbx_test(580, student.lives_with_rel, 'mother', 'Mother')
    cbx_test(630, student.lives_with_rel, 'father', 'Father')
    cbx_test(674, student.lives_with_rel, 'guardian', 'Legal Guardian')
    newline
    txt(66, 'Mailing Address, if different from above')
    txt(282, 'City')
    txt(376, 'State/Zip')
    banner_at(208, 'MOTHER/GUARDIAN', 58, -1)
    tbx(168, student.g1_last, 118)
    tbx(292, student.g1_first, 128)
    tbx(450, student.g1_email, 156)
    tbx(612, student.g1_employer, 118)
    newline
    txt(168, 'Last Name')
    txt(292, 'First')
    txt(450, 'Email')
    txt(612, 'Employer')
    newline_at(236)
    tbx(66, student.g1_street, 150)
    tbx(222, student.g1_city, 148)
    tbx(376, student.g1_zip, 44)
    tbx(450, student.g1_res_phone, 70)
    tbx(526, student.g1_work_phone, 64)
    tbx(596, student.g1_cell, 64)
    tbx(666, student.g1_pager, 64)
    newline
    txt(66, 'Home Address, if different from above')
    txt(292, 'City')
    txt(376, 'State/Zip')
    txt(450, 'Home Phone')
    txt(526, 'Work Phone')
    txt(596, 'Cell Phone')
    txt(666, 'Pager')
    banner_at(264, 'FATHER/GUARDIAN', 58, -1)
    tbx(168, student.g2_last, 118)
    tbx(292, student.g2_first, 128)
    tbx(450, student.g2_email, 156)
    tbx(612, student.g2_employer, 118)
    newline
    txt(168, 'Last Name')
    txt(292, 'First')
    txt(450, 'Email')
    txt(612, 'Employer')
    newline_at(292)
    tbx(66, student.g2_street, 150)
    tbx(222, student.g2_city, 148)
    tbx(376, student.g2_zip, 44)
    tbx(450, student.g2_res_phone, 70)
    tbx(526, student.g2_work_phone, 64)
    tbx(596, student.g2_cell, 64)
    tbx(666, student.g2_pager, 64)
    newline
    txt(66, 'Home Address, if different from above')
    txt(292, 'City')
    txt(376, 'State/Zip')
    txt(450, 'Home Phone')
    txt(526, 'Work Phone')
    txt(596, 'Cell Phone')
    txt(666, 'Pager')
    newline_at(324)
    txt(58, 'Are there any COURT-MANDATED custody/visitation orders limiting access to this student?')
    cbx_test(450, student.custody_orders, '0', 'No')
    cbx(492, student.custody_orders, 'Yes')
    txt(534, 'If Yes, please attach LEGAL ORDER.')
    # newline_at(366)
    # txt(66, 'Languages spoken at home: 1.')
    # tbx(200, fmt_select(LANGUAGE_OPTIONS, student.ca_homelanguage), 220)
    # txt(450, '2.')
    # tbx(462, fmt_select(LANGUAGE_OPTIONS, student.lang_other), 268)
    banner_at(346, 'AUTHORIZED ADULTS', 58, -1)
    newline_at(340)
    txa(190, 530, %{Please list the names of relatives/neighbors/friends in close proximity to the school to whom we may release your child}, 6, true)
    txa(66, 654, %{or contact if you cannot be reached.  NO STUDENT WILL BE RELEASED TO ANYONE OTHER THAN THE PARENTS, GUARDIANS OR ADULTS LISTED ON THIS CARD. In selecting someone to whom you authorize the release of your child, consider: (a) Would your child feel safe and comfortable with this person and family?(b) Could this person care for your child for several days? (c) Is this person prepared to handle any special medical needs required by your child?}, 6)
    newline(44)
    # txa(130, 530, %{I/we hereby authorize the release of the student named above to the following persons in the event of illness, injury, evacuation or emergency that may occur while students are in school.})
    # newline(44)
    txt(66, 'Last Name')
    txt(186, 'First')
    txt(336, 'Relationship')
    txt(436, 'Primary Phone')
    txt(536, 'Alternate Phone')
    newline
    tbx(66, student.emerg_contact_1, 114)
    tbx(186, student.emerg_1_first, 144)
    tbx(336, student.emerg_1_rel, 94)
    tbx(436, student.emerg_phone_1, 94)
    tbx(536, student.emerg_1_alt_phone, 94)
    newline
    tbx(66, student.emerg_contact_2, 114)
    tbx(186, student.emerg_2_first, 144)
    tbx(336, student.emerg_2_rel, 94)
    tbx(436, student.emerg_phone_2, 94)
    tbx(536, student.emerg_2_alt_phone, 94)
    newline
    tbx(66, student.emerg_3_last, 114)
    tbx(186, student.emerg_3_first, 144)
    tbx(336, student.emerg_3_rel, 94)
    tbx(436, student.emerg_3_phone, 94)
    tbx(536, student.emerg_3_alt_phone, 94)
    # newline
    # tbx(66, student.emerg_x_last, 114)
    # tbx(186, student.emerg_x_first, 144)
    # tbx(336, student.emerg_x_rel, 94)
    
    SetFont('ArialNarrow', 'B', 16)
    school = 'Bacich Elementary'
    if student.grade_level.to_i > 4
      school = 'Kent Middle'
    end
    RotatedText(90, 48, 582, "SCHOOL: #{school}")
    RotatedText(90, 48, 366, "STUDENT: #{student.last_name}, #{student.first_name} (#{student.display_grade_level}) HR #{student.home_room}")
  end
    
  def emergency_form_page_2(student)
    new_page(student, 'L', 90)
    newline_at(36)
    txa(36, 720, 'STUDENT EMERGENCY CONTACT CARD', 5, true, 'C')
      txa(36, 720, 'Medical Information and Consent', 2, false, 'C')
    banner_at(78, 'STUDENT', 44, -1)
    tbx(110, student.last_name, 116)
    tbx(232, student.first_name, 116)
    tbx(354, student.middle_name, 116)
    newline
    txt(110, 'Last Name')
    txt(232, 'First')
    txt(354, 'Middle')
    
    # authorization
    banner_at(78, 'EMERGENCY TREATMENT AUTHORIZATION', 514, -1)
    newline_at(90)
    txt(514, 'Authorization and Consent for Emergency Medical Care')
    newline_at(102)
    txt(514, 'Authorization Granted?')
    cbx_test(632, student.release_authorization, '0', 'No')
    cbx(664, student.release_authorization, 'Yes')
    newline_at(110)
    if student.release_authorization
      txa(514, 220, %{I/we, the undersigned parent(s) or legal guardian of}, 4, true)
      txa(514, 150, %{#{student.first_name} #{student.last_name}}, 2)
      txa(664, 70, %{a minor, do hereby}, 4, true)
      txa(514, 220, %{give authorization and consent to the school to obtain emergency medical care and necessary transportation, including x-ray examination, anesthetic, medical or surgical diagnosis and emergency hospital which is deemed advisable by and is to be rendered under the general or specific supervision of medical and emergency room staff licensed under the provisions of the medicine practice act and the State of California Department of Public Health.}, 4, true)
      newline
      txa(514, 220, %{It is understood that effort shall be made to contact the undersigned prior to rendering treatment to the student, but that any of the above treatment will not be withheld if the undersigned or authorized adults cannot be reached.}, 4, true)
      newline
      txa(514, 150, %{#{student.emergency_hospital}}, 2)
      txa(664, 70, %{is the hospital}, 4, true)
      txa(514, 220, %{I/we prefer for emergency medical treatment of my/our child.}, 4, true)
      newline
      txa(514, 220, %{I/we understand that the school district does not provide accident/medical insurance for students, and I/we further understand that all costs related to medical treatment may be my/our responsibility and not that of the school district.}, 4)
      newline_at(400)
      txt(514, 'Parent/Guardian Signature(s)')
      txt(654, 'Date')
      newline_at(416)
      tbx(514, student.signature_1, 100)
      tbx(654, student.responsibility_date, 80)
      newline_at(432)
      tbx(514, student.signature_2, 100)
    end
    # banner_at(437.5, 'VOLUNTEER ASSISTANCE', 514, -1)
    # newline_at(450)
    # txa(514, 220, %{If you live close to school and feel that, if called, you can offer volunteer assistance during an emergency, please provide your name, phone number and expertise.})
    # newline_at(500)
    # txa(514, 220, 'I would like to help in an emergency.', 4, false, 'C')
    # newline_at(542)
    # txt(514, 'Name')
    # txt(694, 'Phone')
    # newline_at(566)
    # txt(514, 'Qualifications')
    
    banner_at(104, 'MEDICAL/HEALTH INFORMATION', 44, -1)
    newline_at(116)
    txt(44, 'Does the student take medication at home or at school?')
    cbx_test(304, student.requires_meds, '0', 'No')
    cbx(336, student.requires_meds, 'Yes')
    newline
    txt(44, 'Medication provided for the student to take at school?')
    cbx_test(304, student.school_meds, '0', 'No')
    cbx(336, student.school_meds, 'Yes')
    newline
    txt(44, '72-hour medication provided to be used in an emergency?')
    cbx_test(304, student.emergency_meds, '0', 'No')
    cbx(336, student.emergency_meds, 'Yes')
    # newline(6)
    # txa(44, 480-44, %{If your child requires medication at school, all medication sent to school must be in the original prescription container with a currrent date and the child's name.  An "Authorization for Administration of Medication" form must be on file.  For disasters, please provide a separate three-day supply for the school office, in the same format, along with the green "72-Hour Disaster Medication" form.  Both forms are available from the school office.})
    # txt(44, 'Medication Form Information')
    # txt(298, 'Dosage')
    # txt(390, 'Hour(s) given')
    # newline_at(214)
    # tbx(58, student.display_school_meds, 200)
    # tbx(58, student.med1_name, 200)
    # tbx(264, student.med1_dosage, 100)
    # tbx(370, student.med1_hours, 100)
    # newline_at(228)
    # tbx(58, student.display_72_hour_meds, 200)
    # tbx(58, student.med2_name, 200)
    # tbx(264, student.med2_dosage, 100)
    # tbx(370, student.med2_hours, 100)
    # newline_at(242)
    # tbx(58, student.med3_name, 200)
    # tbx(264, student.med3_dosage, 100)
    # tbx(370, student.med3_hours, 100)
    # newline_at(258)
    newline(16)
    txt(44, 'Health Insurance Information:')
    newline
    cbx_test(58, student.health_ins_type, 'private', 'Family Health Insurance')
    cbx_test(198, student.health_ins_type, 'hfam', 'Healthy Families')
    cbx_test(304, student.health_ins_type, 'cakids', 'California Kids')
    newline
    cbx_test(58, student.health_ins_type, 'medi-cal', 'Medi-Cal #')
    tbx(120, student.medi_cal_num, 150)
    cbx_test(304, student.health_ins_type, 'none', 'No Health Insurance')
    
    newline
    txt(44, 'Physician/Health Care Provider')
    tbx(180, student.doctor_name, 140)
    txt(324, 'Phone No.')
    tbx(370, student.doctor_phone)
    newline
    txt(44, 'Health Plan/Group Name')
    tbx(180, student.medical_carrier, 140)
    txt(324, 'Policy No.')
    tbx(370, student.medical_policy)
    newline
    txt(44, 'Dentist')
    tbx(180, student.dentist_name, 140)
    txt(324, 'Phone No.')
    tbx(370, student.dentist_phone)
    newline
    txt(44, 'Vision and/or Hearing Problems:')
    newline
    cbx(58, student.eyeglasses, 'Wears glasses/contacts:')
    cbx(198, student.eyeglasses_board, 'for board work')
    cbx(304, student.eyeglasses_reading, 'for reading')
    cbx(404, student.eyeglasses_always, 'all the time')
    newline
    txt(50, 'Date of last eye exam')
    tbx(152, student.h_last_eye_exam)
    cbx(304, student.h_hearing_aid, 'Wears hearing aid(s)')
    
    newline(16)
    txt(44, 'Medical Conditions:')
    newline
    has_allergies = student.allergies_severe || student.allergies_epi_pen ||
      student.allergies_benadryl || student.allergies_food ||
      student.allergies_insects || student.allergies_drugs ||
      student.allergies_other
    cbx(58, has_allergies, 'Severe allergies requiring:')
    cbx(198, student.allergies_epi_pen, 'Epi-pen')
    cbx(304, student.allergies_benadryl, 'Benadryl')
    newline
    cbx(78, student.allergies_food, 'Food/Environmental')
    cbx(198, student.allergies_insects, 'Stinging Insects/Bees')
    cbx(304, student.allergies_drugs, 'Medicines/Drugs')
    cbx(404, student.allergies_other, 'Other')
    newline
    txt(70, 'Please explain:')
    newline
    tbx(70, (student.allergies || '')[0,MAX_FIELD_LENGTH_3], 400, 32)
    newline(36)
    has_asthma = student.asthma || student.asthma_inhaler ||
      student.asthma_medication
    cbx(58, has_asthma, 'Current asthma')
    txt(152, 'If checked,')
    cbx(304, student.asthma_inhaler, 'uses inhaler')
    cbx(376, student.asthma_medication, 'on daily medication')
    newline
    has_seizures = student.seizures || student.seizures_medication
    cbx(58, has_seizures, 'Current seizures')
    txt(152, 'If checked, on medication?')
    cbx(304, student.seizures_medication, 'Yes')
    cbx(376, has_seizures && !student.seizures_medication, 'No')
    newline
    has_diabetes = student.diabetes || student.diabetes_insulin
    cbx(58, has_diabetes, 'Diabetes')
    txt(152, 'If checked, insulin dependent?')
    cbx(304, student.diabetes_insulin, 'Yes')
    cbx(376, has_diabetes && !student.diabetes_insulin, 'No')
    newline
    has_behavior_problems = student.behavior_problems || !student.behavior_issues.blank?
    cbx(58, has_behavior_problems, 'Behavior problems:')
    tbx(166, (student.behavior_issues || '')[0,MAX_FIELD_LENGTH_1], 304)
    newline
    has_movement_limits = student.movement_limits || !student.movement_limits_desc.blank?
    cbx(58, has_movement_limits, 'Movement limitations:')
    tbx(166, (student.movement_limits_desc || '')[0,MAX_FIELD_LENGTH_1], 304)
    newline
    has_medical_other = student.medical_other || !student.medical_considerations.blank?
    cbx(58, has_medical_other, 'Other (please explain):')
    newline
    tbx(70, (student.medical_considerations || '')[0,MAX_FIELD_LENGTH_3], 400, 32)
    newline(36)
    has_illness_recent = student.illness_recent || !student.illness_desc.blank?
    cbx(58, has_illness_recent, 'Recent illness, hospitalization or surgery.  If checked, please provide date(s) and description(s):')
    newline
    tbx(70, (student.illness_desc || '')[0,MAX_FIELD_LENGTH_3], 400, 32)
    newline(36)
    has_medical_accom = student.medical_accom || !student.medical_accom_desc.blank?
    cbx(58, has_medical_accom, 'Medical condition which might requre care or accommodation at school (please describe):')
    newline
    tbx(70, (student.medical_accom_desc || '')[0,MAX_FIELD_LENGTH_3], 400, 32)
    
    # vertical separator
    lin(500, 60, 500, 588)
    
  end
    
end
