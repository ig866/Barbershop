require 'sinatra'
require 'sqlite3'


get '/' do
  erb :index
end


# спросим Имя, Пароль для входа.
post '/' do
  @login = params[:plogin]
  @password = params[:ppass]
  erb :index
# проверим логин и пароль, и пускаем внутрь или нет:
  if @login == 'admin' && @password == 'pass'
    erb :reception_list
  else
    @access_denied_title ='Access denied'
    erb :index
  end
end

# спросим Имя, номер телефона и дату, когда придёт клиент.
post '/reception_list' do
  # user_name, phone, date_time
  @user_name = params[:user_name]
  @phone = params[:phone]
  @date_time = params[:date_time]

  @title = "Thank you!"
  @message = "Уважаемый #{@user_name}, мы ждём вас #{@date_time}"

  # запишем в файл то, что ввёл клиент
  f = File.open './public/users.txt', 'a'
  f.write "User: #{@user_name}, phone: #{@phone}, date and time: #{@date_time}.\n"
  f.close

  erb :message
end

# Зона /admin где по паролю будет выдаваться список тех, кто записался (из users.txt)

# sinatra text file sso
get '/admin' do
  erb :admin
end

post '/admin' do
  @login = params[:login]
  @password = params[:password]

  # проверим логин и пароль, и пускаем внутрь или нет:
  if @login == 'admin' && @password == 'krdprog'
    @file = File.open("./users.txt","r")
    erb :result
    # @file.close - должно быть, но тогда не работает. указал в erb
  else
    @report = '<p>Доступ запрещён! Неправильный логин или пароль.</p>'
    erb :admin
  end
end

post '/registration' do
  @login_reg = params[:login_reg]
  @password_reg = params[:password_reg]

  # Добавил ДБ для сохранения логинов и паролей
  db =SQLite3::Database.new '/db/barbershop_db'
  db.execute "INSERT INTO access VALUES(3,'#{@login_reg}','#{@password_reg}')"
  db.close

  f = File.open './public/users_reg.txt', 'a'
  f.write "User: #{@login_reg}, pass: #{@password_reg}.\n"
  f.close

    erb :index
  end