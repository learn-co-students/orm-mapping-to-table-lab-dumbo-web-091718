class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_reader :id
  attr_accessor :name, :grade

  @@all = []

  def initialize(name, grade)
    @name = name
    @grade = grade
    @@all << self
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      grade TEXT,
      name TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (grade, name)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT * FROM students")[0][0]
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.all
    @@all << self
  end
end
