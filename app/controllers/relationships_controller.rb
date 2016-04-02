class RelationshipsController < ApplicationController
  def create
    user_to_follow_id = params[:followed_id]
    Relationship.create(follower_id: current_user.id, followed_id: user_to_follow_id)
    render user_path(user_to_follow_id)
  end


  def destroy

  end
end
