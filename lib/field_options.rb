TRUE_FALSE_OPTIONS = [ 
  [ 'True', true ],
  [ 'False', false ] ]

FALSE_TRUE_OPTIONS = [ 
  [ 'False', false ], 
  [ 'True', true ] ]

NO_YES_OPTIONS = [ 
  [ 'No', false ], 
  [ 'Yes', true ] ]

YES_NO_OPTIONS = [ 
  [ 'Yes', true ], 
  [ 'No', false ] ]

YES_NO_DONTKNOW_OPTIONS = [ 
  [ 'Yes', '1' ],
  [ 'No', '0' ], 
  [ 'Not sure', '-1' ] ]

SCHOOL_OPTIONS = [
  [ 'Bacich Elementary School', '103' ],
  [ 'Kent Middle School', '104' ] ]
  
NEXT_SCHOOL_OPTIONS = [
  [ 'Bacich Elementary School', '103' ],
  [ 'Kent Middle School', '104' ],
  [ 'Graduating', '999999' ] ]

STAFF_SCHOOL_OPTIONS = [
  [ 'District Office', '102' ],
  [ 'Bacich Elementary School', '103' ],
  [ 'Kent Middle School', '104' ] ]
  
REG_YEAR_OPTIONS = [
  '2007-2008', '2008-2009' ]

SHORT_GRADE_LEVEL = {
  -1 => 'Pre-K',
  0 => 'K',
  1 => '1',
  2 => '2',
  3 => '3',
  4 => '4',
  5 => '5',
  6 => '6',
  7 => '7',
  8 => '8',
}

LONG_GRADE_LEVEL = {
  -1 => 'Pre-Kindergarten',
  0 => 'Kindergarten',
  1 => '1st Grade',
  2 => '2nd Grade',
  3 => '3rd Grade',
  4 => '4th Grade',
  5 => '5th Grade',
  6 => '6th Grade',
  7 => '7th Grade',
  8 => '8th Grade',
}

NEXT_GRADE_LEVEL = {
  0 => 'K',
  1 => '1',
  2 => '2',
  3 => '3',
  4 => '4',
  5 => '5',
  6 => '6',
  7 => '7',
  8 => '8',
  99 => 'Graduating'
}

NEWREG_GRADE_LEVEL_OPTIONS = [ 
  [ 'Will not be attending', '' ],
  [ 'Kindergarten - Bacich Elementary School', 0 ],
  [ '1st Grade - Bacich Elementary School', 1 ],
  [ '2nd Grade - Bacich Elementary School', 2 ],
  [ '3rd Grade - Bacich Elementary School', 3 ],
  [ '4th Grade - Bacich Elementary School', 4 ],
  [ '5th Grade - Kent Middle School', 5 ],
  [ '6th Grade - Kent Middle School', 6 ],
  [ '7th Grade - Kent Middle School', 7 ],
  [ '8th Grade - Kent Middle School', 8 ] ]

SHORT_GRADE_LEVEL_OPTIONS = [
  [ 'K', 0 ],
  [ '1', 1 ],
  [ '2', 2 ],
  [ '3', 3 ],
  [ '4', 4 ],
  [ '5', 5 ],
  [ '6', 6 ],
  [ '7', 7 ],
  [ '8', 8 ] ]

NEXT_GRADE_LEVEL_OPTIONS = [
  [ 'K', 0 ],
  [ '1', 1 ],
  [ '2', 2 ],
  [ '3', 3 ],
  [ '4', 4 ],
  [ '5', 5 ],
  [ '6', 6 ],
  [ '7', 7 ],
  [ '8', 8 ],
  [ 'Graduating', 99 ] ]

PREV_SCHOOL_GRADE_LEVEL_OPTIONS = [ 
  [ 'Pre-Kindergarten', -1 ],
  [ 'Kindergarten', 0 ],
  [ '1st Grade', 1 ],
  [ '2nd Grade', 2 ],
  [ '3rd Grade', 3 ],
  [ '4th Grade', 4 ],
  [ '5th Grade', 5 ],
  [ '6th Grade', 6 ],
  [ '7th Grade', 7 ],
  [ '8th Grade', 8 ] ]

LONG_GRADE_LEVEL_OPTIONS = [ 
  [ 'Kindergarten', 0 ],
  [ '1st Grade', 1 ],
  [ '2nd Grade', 2 ],
  [ '3rd Grade', 3 ],
  [ '4th Grade', 4 ],
  [ '5th Grade', 5 ],
  [ '6th Grade', 6 ],
  [ '7th Grade', 7 ],
  [ '8th Grade', 8 ] ]
 
KENT_GRADE_LEVEL_OPTIONS = [ 
  [ '5th Grade', 5 ],
  [ '6th Grade', 6 ],
  [ '7th Grade', 7 ],
  [ '8th Grade', 8 ] ]
  
GENDER_OPTIONS = [ 'M', 'F' ]

LIVES_WITH_OPTIONS = [ 
  [ 'Both parents', 'both' ],
  [ 'Mother', 'mother' ],
  [ 'Father', 'father' ],
  [ 'Legal guardian', 'guardian' ], 
  [ 'Other', 'other' ] ]

USSTATE_OPTIONS = [
  [ 'CA', 'CA' ],
  [ 'AK', 'AK' ],
  [ 'AL', 'AL' ],
  [ 'AR', 'AR' ],
  [ 'AZ', 'AZ' ],
  [ 'CO', 'CO' ],
  [ 'CT', 'CT' ],
  [ 'DC', 'DC' ],
  [ 'DE', 'DE' ],
  [ 'FL', 'FL' ],
  [ 'GA', 'GA' ],
  [ 'HI', 'HI' ],
  [ 'IA', 'IA' ],
  [ 'ID', 'ID' ],
  [ 'IL', 'IL' ],
  [ 'IN', 'IN' ],
  [ 'KS', 'KS' ],
  [ 'KY', 'KY' ],
  [ 'LA', 'LA' ],
  [ 'MA', 'MA' ],
  [ 'MD', 'MD' ],
  [ 'ME', 'ME' ],
  [ 'MI', 'MI' ],
  [ 'MN', 'MN' ],
  [ 'MO', 'MO' ],
  [ 'MS', 'MS' ],
  [ 'MT', 'MT' ],
  [ 'NC', 'NC' ],
  [ 'ND', 'ND' ],
  [ 'NE', 'NE' ],
  [ 'NH', 'NH' ],
  [ 'NJ', 'NJ' ],
  [ 'NM', 'NM' ],
  [ 'NV', 'NV' ],
  [ 'NY', 'NY' ],
  [ 'OH', 'OH' ],
  [ 'OK', 'OK' ],
  [ 'OR', 'OR' ],
  [ 'PA', 'PA' ],
  [ 'RI', 'RI' ],
  [ 'SC', 'SC' ],
  [ 'SD', 'SD' ],
  [ 'TN', 'TN' ],
  [ 'TX', 'TX' ],
  [ 'UT', 'UT' ],
  [ 'VA', 'VA' ],
  [ 'VT', 'VT' ],
  [ 'WA', 'WA' ],
  [ 'WI', 'WI' ],
  [ 'WV', 'WV' ],
  [ 'WY', 'WY' ],
]
  
NASTATE_OPTIONS = [
  [ 'California', 'CA' ],
  [ 'Alabama', 'AL' ],
  [ 'Alaska', 'AK' ],
  [ 'Arizona', 'AZ' ],
  [ 'Arkansas', 'AR' ],
  [ 'Colorado', 'CO' ],
  [ 'Connecticut', 'CT' ],
  [ 'Delaware', 'DE' ],
  [ 'District of Columbia', 'DC' ],
  [ 'Florida', 'FL' ],
  [ 'Georgia', 'GA' ],
  [ 'Hawaii', 'HI' ],
  [ 'Idaho', 'ID' ],
  [ 'Illinois', 'IL' ],
  [ 'Indiana', 'IN' ],
  [ 'Iowa', 'IA' ],
  [ 'Kansas', 'KS' ],
  [ 'Kentucky', 'KY' ],
  [ 'Louisiana', 'LA' ],
  [ 'Maine', 'ME' ],
  [ 'Maryland', 'MD' ],
  [ 'Massachusetts', 'MA' ],
  [ 'Michigan', 'MI' ],
  [ 'Minnesota', 'MN' ],
  [ 'Mississippi', 'MS' ],
  [ 'Missouri', 'MO' ],
  [ 'Montana', 'MT' ],
  [ 'Nebraska', 'NE' ],
  [ 'Nevada', 'NV' ],
  [ 'New Hampshire', 'NH' ],
  [ 'New Jersey', 'NJ' ],
  [ 'New Mexico', 'NM' ],
  [ 'New York', 'NY' ],
  [ 'North Carolina', 'NC' ],
  [ 'North Dakota', 'ND' ],
  [ 'Ohio', 'OH' ],
  [ 'Oklahoma', 'OK' ],
  [ 'Oregon', 'OR' ],
  [ 'Pennsylvania', 'PA' ],
  [ 'Rhode Island', 'RI' ],
  [ 'South Carolina', 'SC' ],
  [ 'South Dakota', 'SD' ],
  [ 'Tennessee', 'TN' ],
  [ 'Texas', 'TX' ],
  [ 'Utah', 'UT' ],
  [ 'Vermont', 'VT' ],
  [ 'Virginia', 'VA' ],
  [ 'Washington', 'WA' ],
  [ 'West Virginia', 'WV' ],
  [ 'Wisconsin', 'WI' ],
  [ 'Wyoming', 'WY' ],
  [ '--Mexico--', '-M' ],
  [ 'Aguascalientes', 'AG' ],
  [ 'BC Norte', 'BC' ],
  [ 'BC Sur', 'BS' ],
  [ 'Campeche', 'CM' ],
  [ 'Chiapas', 'CS' ],
  [ 'Chihuahua', 'CH' ],
  [ 'Coahuila', 'CU' ],
  [ 'Colima', 'CL' ],
  [ 'Distrito Federal', 'DF' ],
  [ 'Durango', 'DG' ],
  [ 'Estado de Mexico', 'MX' ],
  [ 'Guanajuato', 'GT' ],
  [ 'Guerrero', 'GR' ],
  [ 'Hidalgo', 'HG' ],
  [ 'Jalisco', 'JA' ],
  [ 'Michoacan', 'MIC' ],
  [ 'Morelos', 'MR' ],
  [ 'Nayarit', 'NA' ],
  [ 'Nuevo Leon', 'NL' ],
  [ 'Oaxaca', 'OA' ],
  [ 'Puebla', 'PU' ],
  [ 'Queretaro', 'QT' ],
  [ 'Quintana Roo', 'QR' ],
  [ 'San Luis Potosi', 'SL' ],
  [ 'Sinaloa', 'SI' ],
  [ 'Sonora', 'SO' ],
  [ 'Tabasco', 'TB' ],
  [ 'Tamaulipas', 'TM' ],
  [ 'Tlaxcala', 'TL' ],
  [ 'Veracruz', 'VE' ],
  [ 'Yucatan', 'YU' ],
  [ 'Zacatecas', 'ZA' ],
  [ '--Canada--', '-C' ],
  [ 'Alberta', 'AB' ],
  [ 'British Columbia', 'BC' ],
  [ 'Manitoba', 'MB' ],
  [ 'New Brunswick', 'NB' ],
  [ 'Newfoundland', 'NF' ],
  [ 'Nunavut', 'NT' ],
  [ 'Nova Scotia', 'NS' ],
  [ 'Ontario', 'ON' ],
  [ 'Prince Edward I.', 'PE' ],
  [ 'Quebec', 'PQ' ],
  [ 'Saskatchewan', 'SK' ],
  [ 'Yukon', 'YT' ],
]
  
COUNTRY_OPTIONS = [
  [ 'United States', 'US' ],
  [ 'Mexico', 'MX' ], 
  [ 'Canada', 'CA' ], 
  [ 'Afghanistan', 'AF' ],
  [ 'Albania', 'AL' ],
  [ 'Algeria', 'DZ' ],
  [ 'American Samoa', 'AS' ],
  [ 'Andorra', 'AD' ],
  [ 'Angola', 'AO' ],
  [ 'Anguilla', 'AI' ],
  [ 'Antarctica', 'AQ' ],
  [ 'Antigua and Barbuda', 'AG' ],
  [ 'Argentina', 'AR' ],
  [ 'Armenia', 'AM' ],
  [ 'Aruba', 'AW' ],
  [ 'Australia', 'AU' ],
  [ 'Austria', 'AT' ],
  [ 'Azerbaijan', 'AZ' ],
  [ 'Bahamas', 'BS' ],
  [ 'Bahrain', 'BH' ],
  [ 'Bangladesh', 'BD' ],
  [ 'Barbados', 'BB' ],
  [ 'Belarus', 'BY' ],
  [ 'Belgium', 'BE' ],
  [ 'Belize', 'BZ' ],
  [ 'Benin', 'BJ' ],
  [ 'Bermuda', 'BM' ],
  [ 'Bhutan', 'BT' ],
  [ 'Bolivia', 'BO' ],
  [ 'Bosnia and Herzegovina', 'BA' ],
  [ 'Botswana', 'BW' ],
  [ 'Bouvet Island', 'BV' ],
  [ 'Brazil', 'BR' ],
  [ 'British Indian Ocean Territories', 'IO' ],
  [ 'Brunei Darussalam', 'BN' ],
  [ 'Bulgaria', 'BG' ],
  [ 'Burkina Faso', 'BF' ],
  [ 'Burundi', 'BI' ],
  [ 'Cambodia', 'KH' ],
  [ 'Cameroon', 'CM' ],
  [ 'Cape Verde', 'CV' ],
  [ 'Cayman Islands', 'KY' ],
  [ 'Central African Republic', 'CF' ],
  [ 'Chad', 'TD' ],
  [ 'Chile', 'CL' ],
  [ 'China', 'CN' ],
  [ 'Christmas Island', 'CX' ],
  [ 'Cocos Islands', 'CC' ],
  [ 'Colombia', 'CO' ],
  [ 'Comoros', 'KM' ],
  [ 'Congo', 'CG' ],
  [ 'Cook Islands', 'CK' ],
  [ 'Costa Rica', 'CR' ],
  [ 'Croatia (Hrvatska)', 'HR' ],
  [ 'Cuba', 'CU' ],
  [ 'Cyprus', 'CY' ],
  [ 'Czech Republic', 'CZ' ],
  [ 'Czechoslovakia', 'CS' ],
  [ 'Denmark', 'DK' ],
  [ 'Djibouti', 'DJ' ],
  [ 'Dominica', 'DM' ],
  [ 'Dominican Republic', 'DO' ],
  [ 'East Timor', 'TP' ],
  [ 'Ecuador', 'EC' ],
  [ 'Egypt', 'EG' ],
  [ 'El Salvador', 'SV' ],
  [ 'Equatorial Guinea', 'GQ' ],
  [ 'Eritrea', 'ER' ],
  [ 'Estonia', 'EE' ],
  [ 'Ethiopia', 'ET' ],
  [ 'Falkland Islands', 'FK' ],
  [ 'Faroe Islands', 'FO' ],
  [ 'Fiji', 'FJ' ],
  [ 'Finland', 'FI' ],
  [ 'France, Metropolitan', 'FX' ],
  [ 'France', 'FR' ],
  [ 'French Guiana', 'GF' ],
  [ 'French Polynesia', 'PF' ],
  [ 'French Southern Territories', 'TF' ],
  [ 'Gabon', 'GA' ],
  [ 'Gambia', 'GM' ],
  [ 'Georgia', 'GE' ],
  [ 'Germany', 'DE' ],
  [ 'Ghana', 'GH' ],
  [ 'Gibraltar', 'GI' ],
  [ 'Great Britain (UK)', 'GB' ],
  [ 'Greece', 'GR' ],
  [ 'Greenland', 'GL' ],
  [ 'Grenada', 'GD' ],
  [ 'Guadeloupe', 'GP' ],
  [ 'Guam', 'GU' ],
  [ 'Guatemala', 'GT' ],
  [ 'Guinea-Bissau', 'GW' ],
  [ 'Guinea', 'GN' ],
  [ 'Guyana', 'GY' ],
  [ 'Haiti', 'HT' ],
  [ 'Heard and McDonald Islands', 'HM' ],
  [ 'Honduras', 'HN' ],
  [ 'Hong Kong', 'HK' ],
  [ 'Hungary', 'HU' ],
  [ 'Iceland', 'IS' ],
  [ 'India', 'IN' ],
  [ 'Indonesia', 'ID' ],
  [ 'Iran', 'IR' ],
  [ 'Iraq', 'IQ' ],
  [ 'Ireland', 'IE' ],
  [ 'Israel', 'IL' ],
  [ 'Italy', 'IT' ],
  [ 'Ivory Coast', 'CI' ],
  [ 'Jamaica', 'JM' ],
  [ 'Japan', 'JP' ],
  [ 'Jordan', 'JO' ],
  [ 'Kazakhstan', 'KZ' ],
  [ 'Kenya', 'KE' ],
  [ 'Kiribati', 'KI' ],
  [ 'Korea (North)', 'KP' ],
  [ 'Korea (South)', 'KR' ],
  [ 'Kuwait', 'KW' ],
  [ 'Kyrgyzstan', 'KG' ],
  [ 'Laos', 'LA' ],
  [ 'Latvia', 'LV' ],
  [ 'Lebanon', 'LB' ],
  [ 'Lesotho', 'LS' ],
  [ 'Liberia', 'LR' ],
  [ 'Libya', 'LY' ],
  [ 'Liechtenstein', 'LI' ],
  [ 'Lithuania', 'LT' ],
  [ 'Luxembourg', 'LU' ],
  [ 'Macau', 'MO' ],
  [ 'Macedonia', 'MK' ],
  [ 'Madagascar', 'MG' ],
  [ 'Malawi', 'MW' ],
  [ 'Malaysia', 'MY' ],
  [ 'Maldives', 'MV' ],
  [ 'Mali', 'ML' ],
  [ 'Malta', 'MT' ],
  [ 'Marshall Islands', 'MH' ],
  [ 'Martinique', 'MQ' ],
  [ 'Mauritania', 'MR' ],
  [ 'Mauritius', 'MU' ],
  [ 'Mayotte', 'YT' ],
  [ 'Micronesia', 'FM' ],
  [ 'Moldova', 'MD' ],
  [ 'Monaco', 'MC' ],
  [ 'Mongolia', 'MN' ],
  [ 'Montserrat', 'MS' ],
  [ 'Morocco', 'MA' ],
  [ 'Mozambique', 'MZ' ],
  [ 'Myanmar', 'MM' ],
  [ 'Namibia', 'NA' ],
  [ 'Nauru', 'NR' ],
  [ 'Nepal', 'NP' ],
  [ 'Netherlands Antilles', 'AN' ],
  [ 'Netherlands', 'NL' ],
  [ 'Neutral Zone', 'NT' ],
  [ 'New Caledonia', 'NC' ],
  [ 'New Zealand', 'NZ' ],
  [ 'Nicaragua', 'NI' ],
  [ 'Niger', 'NE' ],
  [ 'Nigeria', 'NG' ],
  [ 'Niue', 'NU' ],
  [ 'Norfolk Island', 'NF' ],
  [ 'Northern Mariana Islands', 'MP' ],
  [ 'Norway', 'NO' ],
  [ 'Oman', 'OM' ],
  [ 'Pakistan', 'PK' ],
  [ 'Palau', 'PW' ],
  [ 'Panama', 'PA' ],
  [ 'Papua New Guinea', 'PG' ],
  [ 'Paraguay', 'PY' ],
  [ 'Peru', 'PE' ],
  [ 'Philippines', 'PH' ],
  [ 'Pitcairn', 'PN' ],
  [ 'Poland', 'PL' ],
  [ 'Portugal', 'PT' ],
  [ 'Puerto Rico', 'PR' ],
  [ 'Qatar', 'QA' ],
  [ 'Reunion', 'RE' ],
  [ 'Romania', 'RO' ],
  [ 'Russian Federation', 'RU' ],
  [ 'Rwanda', 'RW' ],
  [ 'S. Georgia & S. Sandwich Islands', 'GS' ],
  [ 'Saint Kitts and Nevis', 'KN' ],
  [ 'Saint Lucia', 'LC' ],
  [ 'Samoa', 'WS' ],
  [ 'San Marino', 'SM' ],
  [ 'Sao Tome and Principe', 'ST' ],
  [ 'Saudi Arabia', 'SA' ],
  [ 'Senegal', 'SN' ],
  [ 'Seychelles', 'SC' ],
  [ 'Sierra Leone', 'SL' ],
  [ 'Singapore', 'SG' ],
  [ 'Slovak Republic', 'SK' ],
  [ 'Slovenia', 'SI' ],
  [ 'Solomon Islands', 'SB' ],
  [ 'Somalia', 'SO' ],
  [ 'South Africa', 'ZA' ],
  [ 'Spain', 'ES' ],
  [ 'Sri Lanka', 'LK' ],
  [ 'St. Helena', 'SH' ],
  [ 'St. Pierre and Miquelon', 'PM' ],
  [ 'St. Vincent & Grenadines', 'VC' ],
  [ 'Sudan', 'SD' ],
  [ 'Suriname', 'SR' ],
  [ 'Svalbard & Jan Mayen Islands', 'SJ' ],
  [ 'Swaziland', 'SZ' ],
  [ 'Sweden', 'SE' ],
  [ 'Switzerland', 'CH' ],
  [ 'Syria', 'SY' ],
  [ 'Taiwan', 'TW' ],
  [ 'Tajikistan', 'TJ' ],
  [ 'Tanzania', 'TZ' ],
  [ 'Thailand', 'TH' ],
  [ 'Togo', 'TG' ],
  [ 'Tokelau', 'TK' ],
  [ 'Tonga', 'TO' ],
  [ 'Trinidad and Tobago', 'TT' ],
  [ 'Tunisia', 'TN' ],
  [ 'Turkey', 'TR' ],
  [ 'Turkmenistan', 'TM' ],
  [ 'Turks and Caicos Islands', 'TC' ],
  [ 'Tuvalu', 'TV' ],
  [ 'Uganda', 'UG' ],
  [ 'Ukraine', 'UA' ],
  [ 'United Arab Emirates', 'AE' ],
  [ 'United Kingdom', 'UK' ],
  [ 'Uruguay', 'UY' ],
  [ 'US Minor Outlying Islands', 'UM' ],
  [ 'USSR (former)', 'SU' ],
  [ 'Uzbekistan', 'UZ' ],
  [ 'Vanuatu', 'VU' ],
  [ 'Vatican City State', 'VA' ],
  [ 'Venezuela', 'VE' ],
  [ 'Viet Nam', 'VN' ],
  [ 'Virgin Islands (British)', 'VG' ],
  [ 'Virgin Islands (U.S.)', 'VI' ],
  [ 'Wallis and Futuna Islands', 'WF' ],
  [ 'Western Sahara', 'EH' ],
  [ 'Yemen', 'YE' ],
  [ 'Yugoslavia', 'YU' ],
  [ 'Zaire', 'ZR' ],
  [ 'Zambia', 'ZM' ],
  [ 'Zimbabwe', 'ZW' ],
  ]
  
LANGUAGE_OPTIONS = [
  [ 'English'   , '00' ],
  [ 'Spanish'   , '01' ],
  [ 'Albanian'  , '56' ],
  [ 'American Sign Language', '37' ],
  [ 'Arabic'    , '11' ],
  [ 'Armenian'  , '19' ],
  [ 'Assyrian'  , '42' ],
  [ 'Bengali'   , '61' ],
  [ 'Bosnian'   , '52' ],
  [ 'Burmese'   , '13' ],
  [ 'Cambodian' , '09' ],
  [ 'Cantonese' , '03' ],
  [ 'Cebuano'   , '36' ],
  [ 'Chaldean'  , '54' ],
  [ 'Chamorro'  , '20' ],
  [ 'Chaochow'  , '39' ],
  [ 'Chaozhou'  , '39' ],
  [ 'Croatian'  , '14' ],
  [ 'Dutch'     , '15' ],
  [ 'Farsi'     , '16' ],
  [ 'Filipino'  , '05' ],
  [ 'French'    , '17' ],
  [ 'German'    , '18' ],
  [ 'Greek'     , '19' ],
  [ 'Guamanian' , '20' ],
  [ 'Gujarati'  , '43' ],
  [ 'Hebrew'    , '21' ],
  [ 'Hindi'     , '22' ],
  [ 'Hmong'     , '23' ],
  [ 'Hungarian' , '24' ],
  [ 'Ilocano'   , '25' ],
  [ 'Indonesian', '26' ],
  [ 'Italian'   , '27' ],
  [ 'Japanese'  , '08' ],
  [ 'Khmer'     , '09' ],
  [ 'Khmu'      , '50' ],
  [ 'Korean'    , '04' ],
  [ 'Kurdi'     , '51' ],
  [ 'Kurdish'   , '51' ],
  [ 'Kurmanji'  , '51' ],
  [ 'Lahu'      , '47' ],
  [ 'Lao'       , '10' ],
  [ 'Mandarin'  , '07' ],
  [ 'Marshallese', '48' ],
  [ 'Mien'      , '44' ],
  [ 'Mixteco'   , '49' ],
  [ 'Pashto'    , '40' ],
  [ 'Pilipino'  , '05' ],
  [ 'Polish'    , '41' ],
  [ 'Portuguese', '06' ],
  [ 'Punjabi'   , '28' ],
  [ 'Putonghua' , '07' ],
  [ 'Rumanian'  , '45' ],
  [ 'Russian'   , '29' ],
  [ 'Samoan'    , '30' ],
  [ 'Serbian'   , '52' ],
  [ 'Serbo-Croatian', '52' ],
  [ 'Somali'    , '60' ],
  [ 'Tagalog'   , '05' ],
  [ 'Taiwanese' , '46' ],
  [ 'Thai'      , '32' ],
  [ 'Tigrinya'  , '57' ],
  [ 'Toishanese', '53' ],
  [ 'Tongan'    , '34' ],
  [ 'Turkish'   , '33' ],
  [ 'Ukrainian' , '38' ],
  [ 'Urdu'      , '35' ],
  [ 'Vietnamese', '02' ],
  [ 'Visayan'   , '36' ],
  [ 'Yao'       , '44' ],
  [ 'Other'     , '99' ]
  ]
  
ETHNICITY_OPTIONS = [
  [ 'African American', '600' ],
  [ 'Native American', '100' ],
  [ 'Chinese', '201' ],
  [ 'Japanese', '202' ],
  [ 'Korean', '203' ],
  [ 'Vietnamese', '204' ],
  [ 'Asian Indian', '205' ],
  [ 'Laotian', '206' ],
  [ 'Cambodian', '207' ],
  [ 'Other Asian', '299' ],
  [ 'Filipino', '400' ],
  [ 'Latino/Hispanic', '500' ],
  [ 'Hawaiian', '301' ],
  [ 'Samoan', '302' ],
  [ 'Guamanian', '303' ],
  [ 'Tahitian', '304' ],
  [ 'Other Pacific Islander', '399' ],
  [ 'White', '700' ],
  [ 'Decline to state', '999' ]
  ]
  
OTHER_ETHNICITY_OPTIONS = [
  [ :eth2_afr_amer, 'African American', '600' ],
  [ :eth2_amer_indian, 'Native American', '100' ],
  [ :eth2_chinese, 'Chinese', '201' ],
  [ :eth2_japanese, 'Japanese', '202' ],
  [ :eth2_korean, 'Korean', '203' ],
  [ :eth2_vietnamese, 'Vietnamese', '204' ],
  [ :eth2_asian_indian, 'Asian Indian', '205' ],
  [ :eth2_laotian, 'Laotian', '206' ],
  [ :eth2_cambodian, 'Cambodian', '207' ],
  [ :eth2_other_asian, 'Other Asian', '299' ],
  [ :eth2_filipino, 'Filipino', '400' ],
  [ :eth2_hispanic, 'Latino/Hispanic', '500' ],
  [ :eth2_hawaiian, 'Hawaiian', '301' ],
  [ :eth2_samoan, 'Samoan', '302' ],
  [ :eth2_guamanian, 'Guamanian', '303' ],
  [ :eth2_tahitian, 'Tahitian', '304' ],
  [ :eth2_other_islander, 'Other Pacific Islander', '399' ],
  [ :eth2_white, 'White', '700' ] ]
  
PARENT_EDU_OPTIONS = [
  [ 'Not a high school graduate', '14' ],
  [ 'High school graduate', '13' ],
  [ 'Some college (including AA Degree)', '12' ],
  [ 'College graduate', '11' ],
  [ 'Graduate school', '10' ],
  [ 'Unknown or decline to state', '15' ] ]
  
PARENT_REL_OPTIONS = [
  [ 'Mother', 'mother' ],
  [ 'Father', 'father' ],
  [ 'Stepmother', 'stepmother' ],
  [ 'Stepfather', 'stepfather' ],
  [ 'Grandmother', 'grandmother' ],
  [ 'Grandfather', 'grandfather' ],
  [ 'Aunt', 'aunt' ],
  [ 'Uncle', 'uncle' ],
  [ 'Guardian', 'guardian' ],
  [ 'Deceased', 'deceased' ],
  [ 'Other', 'other' ] ]

EMERG_REL_OPTIONS = [
  [ 'Friend', 'friend' ],
  [ 'Child care', 'childcare' ],
  [ 'Father', 'father' ],
  [ 'Mother', 'mother' ],
  [ 'Son', 'son' ],
  [ 'Daughter', 'daughter' ],
  [ 'Father-in-law', 'father-in-law' ],
  [ 'Mother-in-law', 'mother-in-law' ],
  [ 'Brother', 'brother' ],
  [ 'Sister', 'sister' ],
  [ 'Spouse', 'spouse' ],
  [ 'Partner', 'partner' ],
  [ 'Husband', 'husband' ],
  [ 'Wife', 'wife' ],
  [ 'Stepmother', 'stepmother' ],
  [ 'Stepfather', 'stepfather' ],
  [ 'Grandmother', 'grandmother' ],
  [ 'Grandfather', 'grandfather' ],
  [ 'Aunt', 'aunt' ],
  [ 'Uncle', 'uncle' ],
  [ 'Niece', 'niece' ],
  [ 'Nephew', 'nephew' ],
  [ 'Guardian', 'guardian' ],
  [ 'Other', 'other' ] ]

HEALTH_INS_TYPE_OPTIONS = [ 
  [ 'Private Health Insurance', 'private' ],
  [ 'Healthy Families', 'hfam' ],
  [ 'CaliforniaKids', 'cakids' ],
  [ 'Medi-Cal', 'medi-cal' ],
  [ 'None', 'none' ] ]

UNLISTED_OPTIONS = [
  [ 'Listed', 0 ],
  [ 'Unlisted', 1 ] ]

EMAIL_LOCATION_OPTIONS = [
  [ 'Work', 'Work' ],
  [ 'Home', 'Home' ],
  [ 'Both', 'Both' ] ]
  
ELD_OPTIONS = [
  [ 'Not enrolled in any EL program', '6' ],
  [ 'Enrolled in ELD program', '1' ],
  [ 'Enrolled in ELD and SDAIE (no primary language support)', '2' ],
  [ 'Enrolled in ELD and SDAIE with primary language support', '3' ],
  [ 'Enrolled in ELD and academic subjects through primary language', '4' ],
  [ 'Receiving other EL instructional services', '5' ] ]

FLUENCY_OPTIONS = [
  [ 'English is only language spoken', '1' ],
  [ 'English Learner', '3' ],
  [ 'Initially classified as Fluent-English Proficient', '2' ],
  [ 'Reclassified as Fluent-English Proficient', '4' ] ]

SPED504_OPTIONS = [
  [ 'Not in any special ed. or 504 plan', '100' ],
  [ 'Has disability and receives special ed. services', '001' ],
  [ 'Has a section 504 plan', '010' ] ]

DISABILITY_OPTIONS = [
  [ 'No disability', '000' ],
  [ 'MR', '010' ],
  [ 'HH', '020' ],
  [ 'DEAF', '030' ],
  [ 'SLI', '040' ],
  [ 'VI', '050' ],
  [ 'ED', '060' ],
  [ 'OI', '070' ],
  [ 'OHI', '080' ],
  [ 'SLD', '090' ],
  [ 'DB', '100' ],
  [ 'MD', '110' ],
  [ 'AUT', '120' ],
  [ 'TBI', '130' ] ]

CLASS_SIZE_REDUCTION_OPTIONS = [
  [ 'Full day', '10' ],
  [ 'Half day', '01' ] ]

# intent to return form
  
WILL_ATTEND_OPTIONS = [ 
  [ 'Will be attending a District school', 'attending' ],
  [ 'Will have graduated', 'nr-graduated' ],
  [ 'Will not be attending a District school', 'nr-permanent' ], 
  [ 'Is temporarily leaving the District (but may return later)', 'nr-temporary' ],
  [ 'Not sure - don\'t know at this time', 'unknown' ] ]

ENTRY_CODE_OPTIONS = [
  [ 'TM', 'Temporary status' ],
  [ 'ND', 'New to district' ],
  [ 'RD', 'Returned to district' ],
  [ 'PI', 'Promoted at the same school' ],
  [ 'PS', 'Promoted from another school' ],
  [ 'RT', 'Retained at same grade level' ],
  [ 'DM', 'Demoted to lower grade level' ]  ]

EXIT_CODE_OPTIONS = [
  [ 'Not applicable', '' ],
  [ 'Will attend another public school in California', '160' ],
  [ 'Will attend a private school in California', '180' ],
  [ 'Will attend a US school outside California', '200' ],
  [ 'Will be home schooled', '460' ],
  [ 'Is moving to another country', '240' ],
  [ 'Other reason or don\'t know', '400' ] ]

GRADE_5_MUSIC_OPTIONS = [
  [ '5th Grade Chorus', 'chorus' ],
  [ '5th Grade Beginnning Band', 'band' ] ]
  
GRADE_6_MUSIC_OPTIONS = [
  [ '6th Grade Chorus', 'chorus' ],
  [ '6th Grade Intermediate Band', 'band' ] ]
  
GRADE_78_BAND_OPTIONS = [
  [ 'No Band', '' ],
  [ 'Concert Band in 0 Period', 'band' ] ]

GRADE_78_CHOIR_OPTIONS = [
  [ 'No Choir', '' ],
  [ 'Concert Choir in 0 Period', 'choir' ] ]
  
GRADE_8_ENRICHMENT_OPTIONS = [
  [ 'Art', 'art' ],
  [ 'Drama', 'drama' ],
  [ 'Video', 'video' ],
  [ 'Wood Shop', 'shop' ] ]
