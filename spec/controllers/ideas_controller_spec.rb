require 'rails_helper'

RSpec.describe IdeasController, type: :controller do
  def current_user
    @current_user ||= FactoryBot.create(:user)
  end

  describe '#new' do
    context 'with no user signed in' do
      it 'should redirect to session#new' do
        get :new
        expect(response).to redirect_to(new_session_path)
      end

      it 'should set a flash alert message' do
        get :new
        expect(flash[:alert]).to be
      end
    end

    context 'with user signed in' do
      before do
        session[:user_id] = current_user.id
      end

      it 'should render the new template' do
        get :new
        expect(response).to render_template(:new)
      end

      it 'should set an instance variable with a new idea' do
        get :new
        expect(assigns(:idea)).to be_a_new(Idea)
      end
    end
  end

  describe '#create' do
    def valid_request
      post(:create, params: { idea: FactoryBot.attributes_for(:idea) })
    end

    context 'with no user signed in' do
      it 'should redirect to session#new' do
        valid_request
        expect(response).to redirect_to(new_session_path)
      end

      it 'should set a flash alert message' do
        valid_request
        expect(flash[:alert]).to be
      end
    end

    context 'with user signed in' do
      before do
        session[:user_id] = current_user.id
      end

      context 'with valid parameters' do
        it 'should create a new idea in the db' do
          count_before = Idea.count
          valid_request
          count_after = Idea.count
          expect(count_after).to eq(count_before + 1)
        end

        it 'should redirect to the show page of that idea' do
          valid_request
          idea = Idea.last
          expect(response).to redirect_to(idea_path(idea))
        end

        it 'should associate the current_user to the created Idea' do
          valid_request
          idea = Idea.last
          expect(idea.user).to eq(current_user)
        end
      end

      context 'with invalid parameters' do
        def invalid_request
          post(:create, params: { idea: FactoryBot.attributes_for(:idea, title: nil) })
        end

        it 'should assign an invalid idea as an instance variable' do
          invalid_request
          expect(assigns(:idea)).to be_a(Idea)
          expect(assigns(:idea).valid?).to be(false)
        end

        it 'should render the new template' do
          invalid_request
          expect(response).to render_template(:new)
        end

        it 'should not create a job post in the db' do
          count_before = Idea.count
          invalid_request
          count_after = Idea.count
          expect(count_after).to eq(count_before)
        end
      end
    end
  end
end
