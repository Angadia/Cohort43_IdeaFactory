require 'rails_helper'

RSpec.describe IdeasController, type: :controller do
  describe '#new' do
    it 'should render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should set an instance variable with a new idea' do
      get :new
      expect(assigns(:idea)).to be_a_new(Idea)
    end
  end

  describe '#create' do
    def valid_request
      post(:create, params: { idea: FactoryBot.attributes_for(:idea) })
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
