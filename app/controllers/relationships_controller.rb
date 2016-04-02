class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    user_to_follow_id = params[:followed_id]
    Relationship.create(follower_id: current_user.id, followed_id: user_to_follow_id)
    render 'users/show'
  end

  def destroy
    user_to_unfollow_id = params[:followed_id]
    Relationship.destroy(follower_id: current_user.id, followed_id: user_to_unfollow_id)
    render 'users/show'
  end
end
