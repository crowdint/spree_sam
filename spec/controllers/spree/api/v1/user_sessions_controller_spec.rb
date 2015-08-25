require 'spec_helper'

describe Spree::Api::V1::UserSessionsController do
  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:spree_user]
    allow(controller).to receive(:spree_current_user) { user }
  end

  context '#destroy' do
    context 'and json format is used' do
      it 'returns a json with correct data' do
        spree_delete :destroy, format: 'json'
        parsed = ActiveSupport::JSON.decode(response.body)
        expect(parsed).to have_key('session')
      end
    end
  end
end
