require 'date'
require 'yaml'

REGEX = /^(?<gender>[12]) (?<year>\d{2}) (?<month>[01]\d) (?<department>\d{2}) \d{3} \d{3} (?<key>\d{2})$/

def valid_ssn?(ssn, key)
  ssn_without_key = ssn[0..17].delete(' ').to_i
  key.to_i == ((97 - ssn_without_key) % 97)
end

def valid_month?(month)
  month = month.to_i
  p month >= 1 && month <= 12
end

def gender(code)
  { '1' => 'male', '2' => 'female' }[code]
end

def department(code)
  departments = YAML.load_file('data/french_departments.yml')
  departments[code]
end

def french_ssn_info(ssn)
  match_data = ssn.match(REGEX)
  return 'The number is invalid' unless \
    match_data && valid_ssn?(ssn, match_data[:key]) && valid_month?(match_data[:month])

  # Extract info, convert to string, and return
  gender = gender(match_data[:gender])
  year = "19#{match_data[:year]}"
  month = Date::MONTHNAMES[match_data[:month].to_i]
  department = department(match_data[:department])

  # "a male, born in December, 1984 in Seine-Maritime."
  "a #{gender}, born in #{month}, #{year} in #{department}."
end
