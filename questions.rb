require_relative 'questions_database'


class Question
  attr_reader :id
  attr_accessor :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def self.all
    data = QuestionsDatabase.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum)}
  end

  def self.find_by_id(id)
    question_data = QuestionsDatabase.execute(<<-SQL, id: id)
      SELECT
        questions.*
      FROM
        questions
      WHERE
        questions.id = :id
    SQL

    Question.new(question_data.first)
  end

  def self.find_by_author_id(author_id)
    question_data = QuestionsDatabase.execute(<<-SQL, author_id: author_id)
      SELECT
        questions.*
      FROM
        questions
      WHERE
        questions.author_id = :author_id
    SQL

    question_data.map {|author| Question.new(author)}
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end


end
