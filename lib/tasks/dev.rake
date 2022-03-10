require 'tty-spinner'
namespace :dev do
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')
  desc "Ambiente de Desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando DB...') {%x(rails db:drop)}
      show_spinner('Criando DB...') {%x(rails db:create)}
      show_spinner('Migrando DB...') {%x(rails db:migrate)}
      show_spinner('Cadastrando o administrador padrão...'){%x(rails dev:add_default_admin)}
      show_spinner('Cadastrando o administradores...'){%x(rails dev:add_extras_adm)}
      show_spinner('Cadastrando o usuario padrão...'){%x(rails dev:add_default_user)}
      show_spinner("Cadastrando assuntos padrões...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando algumas questões e respostas...") { %x(rails dev:add_answers_and_questions) }
    else
      puts 'Não está em ambiente de desenvolvimento'
    end
  end
  
  desc 'Adicionar o Administradores'
  task add_extras_adm: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: 123456,
        password_confirmation: 123456
      )
    end
  end

  desc "Adiciona assuntos padrão"
  task add_subjects: :environment do
      file_name = 'subjects.txt'
      file_path = File.join(DEFAULT_FILES_PATH, file_name)
      File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona questões e respostas"
  task add_answers_and_questions: :environment do
  Subject.all.each do |subject|
    rand(5..10).times do |i|
      params = { question: {
        description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: []
      }}

      rand(2..5).times do |i|
        params[:question][:answers_attributes].push({
          description: Faker::Lorem.sentence, correct: false
        })
      end

      index = rand(params[:question][:answers_attributes].size)
      params[:question][:answers_attributes][index] = {description: Faker::Lorem.sentence, correct: true}

      Question.create!(params[:question])

      end
    end
  end

  desc 'Adicionar o Administrador'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'adm@adm.com',
      password: 123456,
      password_confirmation: 123456
    )
  end

  desc 'Adicionar o Usuario'
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: 'useruser',
      password_confirmation: 'useruser'
    )
  end
  
  desc "Adiciona perguntas e respostas"
  task add_answers_and_questions: :environment do
  Subject.all.each do |subject|
    rand(5..10).times do |i|
      params = create_question_params(subject)
      answers_array = params[:question][:answers_attributes]
      add_answers(answers_array)
      elect_true_answer(answers_array)
      Question.create!(params[:question])
      end
    end
  end

  desc "Reseta o contador dos assuntos"
  task reset_subject_counter: :environment do
  show_spinner("Resetando contador dos assuntos...") do
    Subject.find_each do |subject|
      Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  private

  def create_question_params(subject = Subject.all.sample)
    { question: {
                  description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
                  subject: subject,
                  answers_attributes: []
                }
    }
  
  end

  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def show_spinner(msg_start,msg_end='Concluido')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  def add_answers(answers_array = [])
    rand(2..5).times do |j|
      answers_array.push(create_answer_params)       
    end  
  end
    
  def elect_true_answer(answers_array = [])
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answer_params(true)    
  end
end
