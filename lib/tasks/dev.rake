require 'tty-spinner'
namespace :dev do
  desc "Ambiente de Desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando DB...') {%x(rails db:drop)}
      show_spinner('Criando DB...') {%x(rails db:create)}
      show_spinner('Migrando DB...') {%x(rails db:migrate)}
      show_spinner('Cadastrando o administrador padrão...'){%x(rails dev:add_default_admin)}
      show_spinner('Cadastrando o administradores...'){%x(rails dev:add_extras_adm)}
      show_spinner('Cadastrando o usuario padrão...'){%x(rails dev:add_default_user)}
     
    else
      puts 'Não está em ambiente de desenvolvimento'
    end
  end
  
  desc 'Adicionar o Administrador'
  task add_extras_adm: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: 123456,
        password_confirmation: 123456
      )
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

private
  
  def show_spinner(msg_start,msg_end='Concluido')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
