require_relative 'questions_database'

class Reply

  attr_accessor :question_id,  :author_id
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = ['body']
  end

  def self.all
    data = QuestionsDatabase.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum)}
  end

  def self.find(id)
    result = QuestionsDatabase.execute(<<-SQL, id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    Reply.new(result)
  end


  def self.find_by_parent_id(parent_id)
    replies_data = QuestionsDatabase.execute(<<-SQL, parent_reply_id: parent_id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.parent_reply_id = :parent_reply_id
    SQL

    replies_data.map { |reply_data| Reply.new(reply_data) }
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.execute(<<-SQL, id: id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.id = :id
    SQL

    Reply.new(result.first)
  end

  def self.find_by_user_id(user_id)
    reply_data = QuestionsDatabase.execute(<<-SQL, user_id: user_id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.author_id = :user_id
    SQL

    reply_data.map { |reply| Reply.new(reply)}
  end

  def self.find_by_question_id(question_id)
    reply_data = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    reply_data.map {|reply| Reply.new(reply)}
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find(parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_id(id)
  end

end
