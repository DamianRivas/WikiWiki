class WikisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
    
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.user = current_user
    
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
    
    authorize @wiki
  end
  
  def update
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    
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
