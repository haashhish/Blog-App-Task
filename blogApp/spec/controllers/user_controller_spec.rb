require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'POST #signUp' do
    context 'when signing up' do
      context 'with valid parameters' do
        it 'creates a new user and returns a token' do
          valid_user_params = {
            user: {
              name: "Example User",
              email: "user@example.com",
              password: "password",
              image: nil
            }
          }

          expect {
            post :signUp, params: valid_user_params
          }.to change(User, :count).by(1)

          expect(JSON.parse(response.body)).to have_key('token')
          expect(JSON.parse(response.body)['message']).to eq('Account create successfully')
        end
      end

      context 'with duplicate email' do
        before { User.create!(name: "Existing User", email: "user@example.com", password: "password") }

        it 'does not create a user and returns an error message' do
          duplicate_user_params = {
            user: {
              name: "Example User",
              email: "user@example.com",  # Duplicate email
              password: "password",
              image: nil
            }
          }

          expect {
            post :signUp, params: duplicate_user_params
          }.not_to change(User, :count)

          expect(JSON.parse(response.body)['message']).to eq('An error has occured')
        end
      end

      context 'with invalid parameters' do
        it 'does not create a user and returns an error message' do
          invalid_user_params = {
            user: {
              name: "Example User",
              email: nil,  # empty email
              password: "password",
              image: nil
            }
          }

          expect {
            post :signUp, params: invalid_user_params
          }.not_to change(User, :count)

          expect(JSON.parse(response.body)['message']).to eq('An error has occured')
        end
      end
    end
  end

  describe 'POST #signIn' do
    before do
      @user = User.create!(
        name: "Example User",
        email: "user@example.com",
        password: "password",
        image: nil
      )
    end

    context 'when signing in' do
      context 'with valid credentials' do
        it 'logs in the user and returns a token' do
          valid_sign_in_params = {
            user: {
              email: @user.email,
              password: @user.password
            }
          }

          post :signIn, params: valid_sign_in_params

          expect(JSON.parse(response.body)).to have_key('token')
          expect(JSON.parse(response.body)['message']).to eq('Logged in')
        end
      end

      context 'with invalid credentials' do
        it 'returns an error message' do
          invalid_sign_in_params = {
            user: {
              email: @user.email,
              password: 'wrongpassword'
            }
          }

          post :signIn, params: invalid_sign_in_params

          expect(JSON.parse(response.body)['message']).to eq('Either no account or incorrect email/password')
        end
      end

      context 'when user does not exist' do
        it 'returns an error message' do
          nonexistent_user_params = {
            user: {
              email: 'user@example.com',
              password: 'password'
            }
          }

          post :signIn, params: nonexistent_user_params

          expect(JSON.parse(response.body)['message']).to eq('Either no account or incorrect email/password')
        end
      end
    end
  end
end
