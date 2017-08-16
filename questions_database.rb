require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end


  # def self.execute(*args)
  #   instance.execute(*args)
  # end
  #
  # def self.get_first_row(*args)
  #   instance.get_first_row(*args)
  # end
  #
  # def self.get_first_value(*args)
  #   instance.get_first_value(*args)
  # end


end
