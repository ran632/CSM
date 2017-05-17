class SnippetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_snippet, only: [:show, :edit, :update, :destroy, :clone]
  before_action :can_manage?, only: [:edit, :update, :destroy]
  before_action :can_read?, only: [:show, :clone]
  respond_to :html

  def index
    user = User.find_by_id(params[:user_id]) if params[:user_id]
    @snippets = Snippet.includes(:user)
    @snippets = @snippets.where(user: user) if user
    respond_with(@snippets)
  end

  def show
    respond_with(@snippet)
  end

  def new
    @snippet = Snippet.new
    respond_with(@snippet)
  end

  def edit
  end

  def create
    @snippet = current_user.snippets.new(snippet_params)
    @snippet.save
    respond_with(@snippet)
  end

  def update
    @snippet.update(snippet_params)
    respond_with(@snippet)
  end

  def destroy
    @snippet.destroy
    respond_with(@snippet)
  end

  def clone
    new_snippet = @snippet.dup
    new_snippet.user = current_user
    new_snippet.save!
    flash[:notice] = "Snippet cloned"
    redirect_to new_snippet
  end

  private
    def set_snippet
      @snippet = Snippet.find(params[:id] || params[:snippet_id])
    end

    def can_manage?
      no_permition unless can? :manage, @snippet
    end

    def can_read?
      no_permition unless can? :read, @snippet
    end

    def no_permition
      flash[:notice] = "No permition"
      redirect_to root_path
    end

    def snippet_params
      params.require(:snippet).permit(:title, :code, :syntax, :privacy_setting)
    end
end
