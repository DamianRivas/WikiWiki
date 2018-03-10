require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) { create(:user) }
  
  # Wiki Attributes:
  # title:string, body:text, private:boolean, user:reference
  let(:wiki) { create(:wiki) }
  
  it { is_expected.to belong_to(:user) }
  
  describe "attributes" do
    it "has title, body, and private attributes" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, private: false)
    end
  end
end
