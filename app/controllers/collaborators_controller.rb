class CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  
  def create
    wiki = Wiki.find(params[:wiki_id])
    user = User.find_by email: params[:collaborator][:user] # user param actually contains an email, not user id
    
    collaborator = wiki.collaborators.build(user: user)
    
    authorize collaborator
    
    if wiki.collaborators.find_by_user_id(user)
      flash[:alert] = "This user is already a collaborator."
      redirect_to edit_wiki_path(wiki) and return
    end
    
    if collaborator.save
      flash[:notice] = "Collaborator added."
    else
      flash[:danger] = "There was an error adding collaborators."
    end
    
    redirect_to edit_wiki_path(wiki)
  end
  
  def destroy
    wiki = Wiki.find(params[:wiki_id])
    collaborator = wiki.collaborators.find(params[:id])
    
    authorize collaborator
    
    if collaborator.destroy
      flash[:notice] = "Collaborator removed."
    else
      flash[:danger] = "Failed to remove collaborators."
    end
    
    redirect_to edit_wiki_path(wiki)
  end
end
