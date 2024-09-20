class UserController < ApplicationController
  skip_before_action :authenticate, only: [:signUp, :signIn]

  def signIn
    @user = User.find_by_email(login_params[:email])
    if @user && @user.authenticate(login_params[:password]) #heck if user exists and password matches
      token = generateToken(@user) #return the token after logging in to use it
      render json: {message:"Logged in", token: token}
    else
      render json: {message:"Either no account or incorrect email/password"}
    end
  end

  def signUp
    @user = User.new(regis_params)
    @user.save
    if @user.save
      token = generateToken(@user) #to generate the token to be used later in authetication
      render json: {token: token, message:"Account create successfully"}
    else
      render json: {message:"An error has occured"}
    end
  end

  private
  def regis_params
    params.require(:user).permit(:name, :email, :password, :image) #image can be a bse64 encoded string
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def generateToken(user)
    secret_key = Rails.application.credentials.secret_key_base #secret key generated
    payload = { user_id: user.id } #payload added
    JWT.encode(payload, secret_key, 'HS256') #HS256 algorithm is used
  end

end
