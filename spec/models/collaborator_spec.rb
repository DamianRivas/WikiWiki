require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  let(:user) { create(:user, role: 'premium') }
  let(:wiki) { create(:wiki, private: true, user: user) }
  let(:other_user) { create(:user) }
  let(:collaborator) { create(:collaborator, user: other_user, wiki: wiki) }
  
  it { is_expected.to belong_to(:wiki) }
  it { is_expected.to belong_to(:user) }
  
  describe "#leader" do
    it "returns the creator of the wiki" do
      expect(collaborator.leader).to eq user
    end
  end
end
