require_relative 'questions'
require_relative 'questions_database'
# require_relative 'question_follow'

class User
  attr_reader :id
  attr_accessor :fname, :lname

  def self.all
    data = QuestionsDatabase.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.execute(<<-SQL, id: id)
      SELECT
        users.*
      FROM
        users
      WHERE
        users.id = :id
    SQL

    User.new(result.first)
  end


  def self.find_by_name(fname, lname)
    name_data = QuestionsDatabase.execute(<<-SQL, fname, lname)
      SELECT
        users.*
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    name_data.map {|data| User.new(data)}
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end


end
