require 'redcarpet'

class WikisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
    @markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      space_after_headers: true,
      superscript: true,
      underline: true
    )
    
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    
    authorize @wiki
  end
  
  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.user = current_user
    if params[:wiki][:private]
      @wiki.private = params[:wiki][:private]
    end
    
    authorize @wiki
    
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:danger] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    @collaborators = Collaborator.where(wiki: @wiki)
    
    authorize @wiki
  end
  
  def update
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    if params[:wiki][:private]
      @wiki.private = params[:wiki][:private]
    end
    
    authorize @wiki
    
    if @wiki.save
      flash[:notice] = "Wiki was updated succesfully."
      redirect_to @wiki
    else
      flash.now[:danger] = "There was an error updating the wiki. Please try again."
      render :edit
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])
    
    authorize @wiki
    
    if @wiki.destroy
      flash[:notice] = "Wiki deleted succesfully."
      redirect_to wikis_path
    else
      flash.now[:danger] = "There was an error deleting the wiki. Please try again."
      render :show
    end
  end
end
