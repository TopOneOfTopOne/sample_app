class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.new(micropost_params)
    if @micropost.save
      flash[:success] = "Created micropost"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @post_to_delete.destroy
    flash[:success] = "Micro post deleted"
    redirect_to request.referer || root_url # request.referer is just previous url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @post_to_delete = Micropost.find_by(id: params[:id])
      redirect_to root_url unless current_user.id == @post_to_delete.user_id
    end
end
