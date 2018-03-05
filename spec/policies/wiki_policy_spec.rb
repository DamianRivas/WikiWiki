require 'rails_helper'

describe WikiPolicy do
  subject { described_class.new(user, wiki) }
  
  let(:wiki) { create(:wiki) }

  context 'being a standard user' do
    let(:user) { create(:user) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_actions([:show, :index]) }
    it { is_expected.to forbid_action(:destroy) }
  end
  
  context 'being an admin user' do
    let(:user) { create(:user, role: "admin") }
    
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_actions([:index, :show, :destroy]) }
  end
end