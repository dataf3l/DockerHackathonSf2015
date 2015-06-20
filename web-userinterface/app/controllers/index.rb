get '/' do
  erb :index
end

get '/breweries' do
  response = HTTParty.get("http://api.brewerydb.com/v2/search/?key=c098f993b1b081a1ef1aa61078ac3503&q=#{params[:q]}")
  status response.code
  @brewery_inquiry = response.body
  {data: @brewery_inquiry}.to_json
end

post '/register' do
   @user = User.create(username: params[:username], password: params[:password])
   # redirect '/'
   {user_name: @user.username}.to_json
end

post '/login' do
  @user = User.where(username: params[:username]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    session[:user_id] = @user.id
    {user_name: @user.username}.to_json
  else
    status 400
    return "we don't know who you are!"
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end