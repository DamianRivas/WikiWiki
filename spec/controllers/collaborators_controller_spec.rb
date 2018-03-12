require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
  let(:user) { create(:user, role: 'premium') }
  let(:wiki) { create(:wiki, private: true, user: user) }
  let(:other_user) { create(:user) }
  
  describe "User adding collaborators on a private wiki they created:" do
    describe "POST #create" do
      context "guest user" do
        it "redirects the user to the sign in view" do
          post :create, params: { wiki_id: wiki.id, user_id: other_user.id }
          
          expect(response).to redirect_to(new_user_session_path)
        end
      end
      
      context "standard user" do
        before do
          user.standard!
          sign_in user
        end
        
        it "redirects the user to the home page" do
          expect(other_user.collaborators.find_by_wiki_id(wiki.id)).to be_nil
          
          post :create, params: { wiki_id: wiki.id, user_id: other_user.id }
          
          expect(response).to redirect_to(root_path)
        end
      end
      
      context "premium user" do
        before do
          sign_in user
        end
        
        it "designates the specified user as a collaborator on the specified wiki" do
          expect(other_user.collaborators.find_by_wiki_id(wiki.id)).to be_nil
          
          post :create, params: { wiki_id: wiki.id, user_email: other_user.email }
          
          expect(other_user.collaborators.find_by_wiki_id(wiki.id)).not_to be_nil
          expect(wiki.collaborators.find_by_user_id(other_user.id)).not_to be_nil
        end
        
        it "redirects to the specified wiki's edit page" do
          post :create, params: { wiki_id: wiki.id, user_email: other_user.email }
          
          expect(response).to redirect_to edit_wiki_path(wiki)
        end
      end
      
      context "admin user" do
        before do
          user.admin!
          sign_in user
        end
        
        it "designates the specified user as a collaborator on the specified wiki" do
          expect(other_user.collaborators.find_by_wiki_id(wiki.id)).to be_nil
          
          post :create, params: { wiki_id: wiki.id, user_email: other_user.email }
          
          expect(other_user.collaborators.find_by_wiki_id(wiki.id)).not_to be_nil
          expect(wiki.collaborators.find_by_user_id(other_user.id)).not_to be_nil
        end
        
        it "redirects to the specified wiki's edit page" do
          post :create, params: { wiki_id: wiki.id, user_email: other_user.email }
          
          expect(response).to redirect_to edit_wiki_path(wiki)
        end
      end
    end
    
    describe "DELETE #destroy" do
      context "guest user" do
        it "redirects the user to the sign in view" do
          collaborator = wiki.collaborators.where(user_id: other_user).create
          delete :destroy, params: { wiki_id: wiki.id, id: collaborator.id }
          
          expect(response).to redirect_to(new_user_session_path)
        end
      end
      
      context "standard user" do
        before do
          user.standard!
          sign_in user
        end
        
        it "redirects the user to the home page" do
          collaborator = wiki.collaborators.where(user_id: other_user).create
          delete :destroy, params: { wiki_id: wiki.id, id: collaborator.id }
          
          expect(response).to redirect_to(root_path)
        end
      end
      
      context "premium user" do
        before do
          sign_in user
        end
        
        it "destroys the specified collaborator for the specified wiki" do
          collaborator = wiki.collaborators.where(user_id: other_user).create
          
          expect(wiki.collaborators.find_by_user_id(other_user.id)).not_to be_nil
          
          delete :destroy, params: { wiki_id: wiki.id, id: collaborator.id }
          
          expect(wiki.collaborators.find_by_user_id(other_user.id)).to be_nil
        end
        
        it "redirects to the specified wiki's edit page" do
          post :create, params: { wiki_id: wiki.id, user_email: other_user.email }
          
          expect(response).to redirect_to edit_wiki_path(wiki)
        end
      end
      
      context "admin user" do
        before do
          user.admin!
          sign_in user
        end
        
        it "destroys the specified collaborator for the specified wiki" do
          collaborator = wiki.collaborators.where(user_id: other_user).create
          
          expect(wiki.collaborators.find_by_user_id(other_user.id)).not_to be_nil
          
          delete :destroy, params: { wiki_id: wiki.id, id: collaborator.id }
          
          expect(wiki.collaborators.find_by_user_id(other_user.id)).to be_nil
        end
        
        it "redirects to the specified wiki's edit page" do
          post :create, params: { wiki_id: wiki.id, user_email: other_user.email }
          
          expect(response).to redirect_to edit_wiki_path(wiki)
        end
      end
    end
  end
end
