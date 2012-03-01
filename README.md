```ruby
require 'DUI'
require 'awesome_print'

class Person
  attr_accessor :name, :email
  def initialize(hash = {})
    hash.each_pair { |k,v| self.send((k.to_s+"=").to_sym, v)}
  end
end

current_data = [Person.new(:email => 'john@galt.com', :name => "JG"),
                Person.new(:email => 'howard@roark.com', :name => "H Roark"),
                Person.new(:email => 'peter@keating.com', :name => "Peter Keating")]

new_data = [{:email => "howard@roark.com", :name => "Howard Roark"},
            {:email => "john@galt.com", :name => "John Galt"},
            {:email => "hank@rearden.com", :name => "Hank Rearden"}]

a_way_to_match_the_records = lambda {|current, new| current.email == new[:email]}

matcher = DUI::Matcher.new(&a_way_to_match_the_records)
results = matcher.get_results current_data, new_data

results.records_to_delete.each do |delete_me|
  current_data.delete delete_me # bye peter!
end

results.records_to_update.each do |match|
  match.current.name = match.new[:name] #fix those names!
end

results.records_to_insert.each do |add_me|
  new_person = Person.new :email => add_me[:email], :name => add_me[:name]
  current_data << new_person # hello hank!
end

ap current_data

```

```ruby
[
    [0] #<Person:0x7ffae4937920
        attr_accessor :email = "john@galt.com",
        attr_accessor :name = "John Galt"
    >,
    [1] #<Person:0x7ffae49376c8
        attr_accessor :email = "howard@roark.com",
        attr_accessor :name = "Howard Roark"
    >,
    [2] #<Person:0x7ffae4966bf8
        attr_accessor :email = "hank@rearden.com",
        attr_accessor :name = "Hank Rearden"
    >
]
```