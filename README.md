#DUI
## Delete, Update, and Insert

The purpose of this gem is to make it easy to compare two datasets to see what operations would be necessary to merge the new data into the old.

Way back in my stored procedure days, we'd write this type of update by:

1.) Deleting any current records that aren't in the new set,
2.) Updating the current records with any matches in the new set, and
3.) Inserting any new records into the current set.

This gem helps to run this process by doing the comparison for you, giving you three sets of data that you can use to make the appropriate data changes.

**Warning:** All of the work is done in memory, so I would not run it against millions of records.  But for small-to-medium sets of data, it might be of some help.

### My inspiration? ###

Two things:

1.) I love that Ruby's syntax makes it easy to write code that executes a *process*, regardless of the objects being used (and without going crazy with things like generics). We'd used to write these DUI sprocs by hand, different for each table. I guess object-oriented languages have some benefits...

2.) I've seen a number of imports that start with an call to **destroy_all**, so an import is essentially a DELETE EVERYTHING, THEN IMPORT EVERYTHING AS NEW process.  Yikes.  After having to fix a few issues where the system would fail *after* the data was deleted but *before* the import was finished, I had to take action.

Simple Example:

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

# create a matcher, provide it with a way to compare the two records
matcher = DUI::Matcher.new(&a_way_to_match_the_records)

# get the results of the matches between the two sets
results = matcher.get_results current_data, new_data

# now we know which records to delete, update, or insert, so let's do it

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
Here's the final result:

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